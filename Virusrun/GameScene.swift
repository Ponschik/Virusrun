//
//  GameScene.swift
//  Virusrun
//
//  Created by Olga Koschel on 17.05.15.
//  Copyright (c) 2015 Olga Koschel & Sebastian Klotz. All rights reserved.
//

import SpriteKit
import CoreMotion
import CoreLocation

enum CollisionType: UInt32 {
    case Bob = 1
    case Floater = 2
    case Attacker = 4
    case Wall = 8
    case Cave = 16
}

enum FieldType: UInt32 {
    case bobGravity = 1
}

class GameScene: SKScene, CLLocationManagerDelegate, SKPhysicsContactDelegate {
    
    let motionManager = CMMotionManager()
    let locationManager = CLLocationManager()
    var locationManagerReady: Bool = false
    
    var startBeaconRegion : CLBeaconRegion!
    var finishBeaconRegion : CLBeaconRegion!
    
    let altimeter = CMAltimeter()
    
    let gameworld = Gameworld()
    let interface = Interface()
    
    var amplify:Float = 0.5
    var shakeFilter:Float = 0.16
    
    var xAccel:Float = 0
    var yAccel:Float = 0
    
    var penalty = 5
    var magneticDirection : CLLocationDirection = 0
    
    override func didMoveToView(view: SKView) {
        
        //---- motion manager ----
        motionManager.startAccelerometerUpdates()
        
        //---- location manager ----
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingHeading()
        
        //---- iBeacon ----
        initBeaconReagions()
        
         //---- physics implementation ----
        self.physicsWorld.contactDelegate = self
        
        addChild(gameworld)
        gameworld.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        
        addChild(interface)
//        interface.zPosition = 10
        interface.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        interface.updateShakeLabel(shakeFilter)
        
        backgroundColor = SKColor(red: 1, green: 0.756, blue: 0.595, alpha: 1)
        
        let foreground = SKSpriteNode(imageNamed: "microscopeMask2.png")
        foreground.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        foreground.zPosition = 50
        addChild(foreground)
        
//        if CMAltimeter.isRelativeAltitudeAvailable() {
//            // 2
//            altimeter.startRelativeAltitudeUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { data, error in
//                // 3
//                if (error == nil) {
//                    println("Relative Altitude: \(data.relativeAltitude)")
//                    println("Pressure: \(data.pressure)")
//                }
//            })
//        }
        
    }
    
//    -(void)initRegion {
//    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"];
//    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Eierlauf"];
//    [self.locationManager startMonitoringForRegion:self.beaconRegion];
//    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
//    }

    func initBeaconReagions() {
        let uuid = NSUUID(UUIDString: "74278BDA-B644-4520-8F0C-720EAF059935")
        startBeaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 1, identifier: "Start")
        finishBeaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 2, identifier: "Finish")
        locationManager.startMonitoringForRegion(startBeaconRegion)
        locationManager.startMonitoringForRegion(finishBeaconRegion)
        locationManager.startRangingBeaconsInRegion(startBeaconRegion)
        locationManager.startRangingBeaconsInRegion(finishBeaconRegion)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
    }
    
    
   
    override func update(currentTime: CFTimeInterval) {
        processMotion(currentTime)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        locationManagerReady = true
    }
    
    
    
    func processMotion(currentTime: CFTimeInterval){
        
        if let accData = motionManager.accelerometerData  {
        
        var accelX : NSNumber? = accData.acceleration.x
        var accelY : NSNumber? = accData.acceleration.y
        
        if accelX == nil {
            accelX = 0
        }
        
        if accelY == nil {
            accelY = 0
        }
        
        xAccel = Float(accelX!) * shakeFilter + xAccel * (1.0 - shakeFilter)
        yAccel = Float(accelY!) * shakeFilter + yAccel * (1.0 - shakeFilter)
            
        }
        
        let xPos = Float(512) * yAccel * amplify * 1
        let yPos = Float(512) * xAccel * amplify * -1
        
//        physicsWorld.gravity = CGVectorMake(CGFloat(xPos * 0.1), CGFloat(yPos * 0.1))
        
        // Winkel Babbels zur Mitte
//        var angle = atan(atan2f(yPos, xPos))
        
        //Radians 0 .. 2PI
//        if angle < 0 { angle = Float(M_PI) + (Float(M_PI) + angle) }
        
        // Maximaler X und Y Wert an bestimmter Stelle des Kreises
//        float xMax = self.maxDistance * cosf(angle);
//        float yMax = self.maxDistance * sinf(angle);
        
        gameworld.bob.position = CGPointMake(CGFloat(xPos), CGFloat(yPos))
        
        let magnetFilter = 0.2
        
        if locationManagerReady {
            if fabs(magneticDirection - locationManager.heading.magneticHeading) > 300 {
                magneticDirection = locationManager.heading.magneticHeading
            }
            
            magneticDirection = locationManager.heading.magneticHeading * magnetFilter + magneticDirection * (1.0 - magnetFilter)
            
            gameworld.bob.zRotation = CGFloat((magneticDirection * M_PI / 180) + M_PI)
        }
    }
    
    override func didSimulatePhysics(){
//        moveCamera()
    }
    
    func moveCamera() {
        
        let bg1Speed:CGFloat = 0.8
        let bg2Speed:CGFloat = 0.6
        let bg3Speed:CGFloat = 0.4
        
        gameworld.playground.position = CGPointMake(-gameworld.bob.position.x, -gameworld.bob.position.y)
        
        gameworld.background1.position = CGPointMake(gameworld.playground.position.x * bg1Speed, gameworld.playground.position.y * bg1Speed)
        gameworld.background2.position = CGPointMake(gameworld.playground.position.x * bg2Speed, gameworld.playground.position.y * bg2Speed)
        gameworld.background3.position = CGPointMake(gameworld.playground.position.x * bg3Speed, gameworld.playground.position.y * bg3Speed)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody, secondBody : SKPhysicsBody
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        }
        else {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        // Check for Projectile
        if (firstBody.categoryBitMask == CollisionType.Bob.rawValue && secondBody.categoryBitMask == CollisionType.Floater.rawValue) {
            let bob : Bob = firstBody.node as! Bob
            let floater : FloatingBacteria = secondBody.node as! FloatingBacteria
            
            floater.colorBlendFactor += 0.1
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        var firstBody, secondBody : SKPhysicsBody
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        }
        else {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        // Check for Projectile
        if (firstBody.categoryBitMask == CollisionType.Bob.rawValue && secondBody.categoryBitMask == CollisionType.Floater.rawValue) {
            let bob : Bob = firstBody.node as! Bob
            let floater : FloatingBacteria = secondBody.node as! FloatingBacteria
            
            floater.colorBlendFactor += 0.1
        }
    }
}