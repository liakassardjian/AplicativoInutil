//
//  MotionManager.swift
//  SensorTesting
//
//  Created by Lia Kassardjian on 15/04/20.
//  Copyright © 2020 Lia Kassardjian. All rights reserved.
//

import UIKit
import CoreMotion

class MotionManager {
    
    let motion = CMMotionManager()
    let gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()
    
    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            let timer = Timer(
                fire: Date(),
                interval: (1.0 / 60.0),
                repeats: true,
                block: { (timer) in
                    if let data = self.motion.deviceMotion {
                        let grav = data.gravity
                
                        let x = CGFloat(grav.x)
                        let y = CGFloat(grav.y)
                        let v = CGVector(dx: x, dy: -y)
                        self.gravity.gravityDirection = v
                    }
            })
            
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        }
    }

}
