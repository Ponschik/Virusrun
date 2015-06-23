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
    case BobHull = 2
    case Protector = 4
    case SaveArea = 8
    case Floater = 16
    case Attacker = 32
    case Infusion = 64
    case BobPuff = 128
}

enum FieldType: UInt32 {
    case BobGravity = 1
    case SaveAreaGravity = 2
}

enum GameState {
    case breedStation
    case breedToTransformWay
    case transformStation
    case transformToMedifierWay
    case medifierStation
    case medifierToBreedWay
}

struct GameColors {
    static var bgColor : UIColor = UIColor(red:0.996, green:0.498, blue:0.490, alpha: 1)
    static var turksieColor : UIColor = UIColor(red:0.125, green:0.741, blue:0.616, alpha: 1)
    static var navy : UIColor = UIColor(red:0.184, green:0.200, blue:0.322, alpha: 1)
}



class GameScene: SKScene, CLLocationManagerDelegate, SKPhysicsContactDelegate {
    
    let motionManager = CMMotionManager()
    let locationManager = CLLocationManager()
    var locationManagerReady: Bool = false
    
    var startBeaconRegion : CLBeaconRegion!
    var finishBeaconRegion : CLBeaconRegion!
    
    let altimeter = CMAltimeter()
    
    let visibleContent = SKNode()
    let gameworld = Gameworld()
    let interface = Interface()
    let startScreen = StartScreen()
    let finishScreen = FinishScreen()
    
    var amplify:Float = 0.5
    var shakeFilter:Float = 0.16
    
    var xAccel:Float = 0
    var yAccel:Float = 0
    
    var gameplayActive : Bool = true
    
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
        
        visibleContent.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        addChild(visibleContent)
        
        visibleContent.addChild(gameworld)
//        gameworld.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        
        visibleContent.addChild(interface)
//        interface.zPosition = 10
//        interface.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        interface.updateShakeLabel(shakeFilter)
        interface.zPosition = 1000
        
        startScreen.hidden = true
        startScreen.zPosition = 100
        visibleContent.addChild(startScreen)
        
        finishScreen.hidden = true
        finishScreen.zPosition = 100
        visibleContent.addChild(finishScreen)
        
//        backgroundColor = SKColor(red: 1, green: 0.756, blue: 0.595, alpha: 1)
//        backgroundColor = SKColor(red: 0, green: 0.72, blue: 0.918, alpha: 1)
//        backgroundColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
        backgroundColor = UIColor(red:0.996, green:0.498, blue:0.490, alpha: 1)
        
        let foreground = SKSpriteNode(imageNamed: "microscopeMask2.png")
        foreground.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        foreground.zPosition = 50
        addChild(foreground)
        
    }
    
    func floaterExplode(pos: CGPoint) {
        var emitterNode = SKEmitterNode(fileNamed: "FloaterExplosion.sks")
        
    }

    
    func shakeCamera(duration:Float) {
        let amplitudeX:Float = 10;
        let amplitudeY:Float = 6;
        let numberOfShakes = duration / 0.04;
        var actionsArray : [SKAction] = [];
        for index in 1...Int(numberOfShakes) {
            // build a new random shake and add it to the list
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
            let shakeAction = SKAction.moveByX(CGFloat(moveX), y: CGFloat(moveY), duration: 0.02);
            shakeAction.timingMode = SKActionTimingMode.EaseOut;
            actionsArray.append(shakeAction);
            actionsArray.append(shakeAction.reversedAction());
        }
        
        let actionSeq = SKAction.sequence(actionsArray);
        visibleContent.runAction(actionSeq);
    }

    func initBeaconReagions() {
        let uuid = NSUUID(UUIDString: "74278BDA-B644-4520-8F0C-720EAF059935")
        startBeaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 1, identifier: "Start")
        finishBeaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 2, identifier: "Finish")
        locationManager.startMonitoringForRegion(startBeaconRegion)
        locationManager.startMonitoringForRegion(finishBeaconRegion)
        locationManager.startRangingBeaconsInRegion(startBeaconRegion)
        locationManager.startRangingBeaconsInRegion(finishBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        locationManager.startMonitoringForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        locationManager.startMonitoringForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        locationManager.stopMonitoringForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if (region == startBeaconRegion) {
            if (beacons.count > 0) {
                var beacon = CLBeacon()
                beacon = beacons.last as! CLBeacon
                if (beacon.proximity == CLProximity.Immediate) {
                    println("SHOW START SCREEN")
                    enterStartScreen()
                } else {
                    exitStartScreen()
                }
            }
        }
        if (region == finishBeaconRegion) {
            if (beacons.count > 0) {
                var beacon = CLBeacon()
                beacon = beacons.last as! CLBeacon
                if (beacon.proximity == CLProximity.Immediate) {
                    println("SHOW FINISH SCREEN")
                    enterFinishScreen()
                } else {
                    exitFinishScreen()
                }
            }
        }
    }
    
    func enterStartScreen() {
        stopGameplay()
        startScreen.hidden = false
    }
    
    func exitStartScreen() {
        startGameplay()
        startScreen.hidden = true
    }
    
    func enterFinishScreen() {
        stopGameplay()
        finishScreen.hidden = false
    }
    
    func exitFinishScreen() {
        startGameplay()
        finishScreen.hidden = true
    }
    
    func stopGameplay() {
        if(gameplayActive) {
            gameplayActive = false
            gameworld.removeFloaters()
            gameworld.saveArea.removeAllActions()
            gameworld.attacker.hidden = true
        }
        
    }
    
    func startGameplay() {
        if(!gameplayActive) {
            gameplayActive = true
            gameworld.addFloater()
            gameworld.saveArea.generateMoveAction()
            gameworld.moveAttacker()
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
    }
    
    
   
    override func update(currentTime: CFTimeInterval) {
        processMotion(currentTime)
//        println("Contacts: \(gameworld.bob.numOfContacts)")
        gameworld.update(currentTime)
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
        
//        gameworld.bob.position = CGPointMake(CGFloat(xPos), CGFloat(yPos))
        gameworld.bobHull.position = CGPointMake(CGFloat(xPos), CGFloat(yPos))
        
        let magnetFilter = 0.2
        
        if locationManagerReady {
            if fabs(magneticDirection - locationManager.heading.magneticHeading) > 300 {
                magneticDirection = locationManager.heading.magneticHeading
            }
            
            magneticDirection = locationManager.heading.magneticHeading * magnetFilter + magneticDirection * (1.0 - magnetFilter)
            
            gameworld.bobHull.zRotation = CGFloat((magneticDirection * M_PI / 180) + M_PI) //* CGFloat(-1)
//            gameworld.rotateArea.zRotation = CGFloat((magneticDirection * M_PI / 180) + M_PI)
//            gameworld.rotateFloater(CGFloat((magneticDirection * M_PI / 180) + M_PI))
        }
    }
    
    override func didSimulatePhysics(){
        moveCamera()
    }
    
    override func didFinishUpdate() {
        gameworld.didFinishUpdate()
    }
    
    func moveCamera() {
        
        let bg1Speed:CGFloat = -0.3
        let bg2Speed:CGFloat = -0.2
        let bg3Speed:CGFloat = -0.1
        let pgSpeed:CGFloat = 0
        
//        gameworld.playground.position = CGPointMake(-gameworld.bob.position.x, -gameworld.bob.position.y)
//        
//        gameworld.background1.position = CGPointMake(gameworld.playground.position.x * bg1Speed, gameworld.playground.position.y * bg1Speed)
//        gameworld.background2.position = CGPointMake(gameworld.playground.position.x * bg2Speed, gameworld.playground.position.y * bg2Speed)
//        gameworld.background3.position = CGPointMake(gameworld.playground.position.x * bg3Speed, gameworld.playground.position.y * bg3Speed)
        gameworld.background1.position = CGPointMake(gameworld.bobHull.position.x * bg1Speed, gameworld.bobHull.position.y * bg1Speed)
        gameworld.background2.position = CGPointMake(gameworld.bobHull.position.x * bg2Speed, gameworld.bobHull.position.y * bg2Speed)
        gameworld.background3.position = CGPointMake(gameworld.bobHull.position.x * bg3Speed, gameworld.bobHull.position.y * bg3Speed)
//        gameworld.playground.position = CGPointMake(gameworld.bobHull.position.x * pgSpeed, gameworld.bobHull.position.y * pgSpeed)
        
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
//        if (firstBody.categoryBitMask == CollisionType.Bob.rawValue && secondBody.categoryBitMask == CollisionType.Floater.rawValue) {
//            let bob : Bob = firstBody.node as! Bob
//            let floater : FloatingBacteria = secondBody.node as! FloatingBacteria
//            
////            floater.colorBlendFactor += 0.1
////            floater.color = SKColor.blackColor()
////            bob.floaterHit()
//            floater.bobContact(bob)
//            
////            gameworld.saveArea.bobHitFloater()
//        }
        
        if (firstBody.categoryBitMask == CollisionType.BobHull.rawValue && secondBody.categoryBitMask == CollisionType.Floater.rawValue) {
            let bobHull : BobHull = firstBody.node?.parent as! BobHull
            let floater : FloatingBacteria = secondBody.node as! FloatingBacteria
            
            //            floater.colorBlendFactor += 0.1
            //            floater.color = SKColor.blackColor()
            //            bob.floaterHit()
            
            
            // Prevent players from shaking to quick / avoiding floating bacteria load to explosion time (explode when hitAction completed)
            if (gameworld.bobFarOut()) {
                floater.bobHullContactDirectHit(bobHull)
            } else {
                floater.bobHullContact(bobHull)
            }
            
            
//            shakeCamera(0.3)
            //            gameworld.saveArea.bobHitFloater()
        }
        
        
        if (firstBody.categoryBitMask == CollisionType.BobHull.rawValue && secondBody.categoryBitMask == CollisionType.Infusion.rawValue) {
            let bobHull : BobHull = firstBody.node?.parent as! BobHull
            let particle : SKSpriteNode = secondBody.node as! SKSpriteNode
            
            var transfuseAction : SKAction = particle.userData!.objectForKey("transfuseAction") as! SKAction
            
            if(particle.actionForKey("transfuse") == nil) {
                particle.removeActionForKey("decay")
                particle.runAction(transfuseAction, withKey: "transfuse")
                bobHull.transfuse()
            }
            
//            var fadeOut = SKAction.scaleTo(0, duration: 1.5)
//            
//            var completion = SKAction.runBlock { () -> Void in
//                particle.removeFromParent()
//            }
//            
//            var transfuseAction = SKAction.sequence([fadeOut, completion])
//            
//            if(particle.actionForKey("transfuse") == nil) {
//                particle.runAction(transfuseAction, withKey: "transfuse")
//            }
            
        }
        
        
        if (firstBody.categoryBitMask == CollisionType.Protector.rawValue && secondBody.categoryBitMask == CollisionType.Attacker.rawValue) {
//            let bobHull : BobHull = firstBody.node as! BobHull
//            if var attacker : Virus = secondBody.node as! Virus {
//                
//            }
            
            //            floater.colorBlendFactor += 0.1
            //            floater.color = SKColor.blackColor()
            //            bob.floaterHit()
//            floater.bobHullContact(bobHull)
            //            shakeCamera(0.3)
            //            gameworld.saveArea.bobHitFloater()
//            attacker.removeFromParent()
            gameworld.newAttacker()
//            println("ATTACK")
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
        if (firstBody.categoryBitMask == CollisionType.BobHull.rawValue && secondBody.categoryBitMask == CollisionType.Floater.rawValue) {
            let bobHull : BobHull = firstBody.node?.parent as! BobHull
            let floater : FloatingBacteria = secondBody.node as! FloatingBacteria
            
//            floater.colorBlendFactor += 0.1
//            floater.color = floater.cherryRed
            bobHull.floaterEndContact()
            floater.bobEndContact()
        }
    }
}