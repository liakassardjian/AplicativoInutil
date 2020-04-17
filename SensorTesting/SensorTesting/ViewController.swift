//
//  ViewController.swift
//  SensorTesting
//
//  Created by Lia Kassardjian on 17/06/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var motionManager: MotionManager?
            
    var balls = [CustomBall]()
    var ball: CustomBall?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .background
        
        motionManager = MotionManager(view: self.view)
        motionManager?.startDeviceMotion()
        addBalls()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        motionManager?.motion.stopDeviceMotionUpdates()
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            ball = checkTouch(t)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self.view)
            
            if let snap = motionManager?.snap {
                motionManager?.animator.removeBehavior(snap)
            }
            
            guard let b = ball else { return }
            motionManager?.snap = UISnapBehavior(item: b, snapTo: location)
            
            if let snap = motionManager?.snap {
                motionManager?.animator.addBehavior(snap)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            if let snap = motionManager?.snap {
                motionManager?.animator.removeBehavior(snap)
                motionManager?.snap = nil
            }
            ball = nil
        }
    }
    
    func checkTouch(_ touch: UITouch) -> CustomBall? {
        for ball in balls {
            if ball.frame.contains(touch.location(in: view)) {
                return ball
            }
        }
        return nil
    }
    
    func calculatePositions() -> [CGPoint] {
        guard let view = self.view else { return [] }
        
        let height = view.frame.height
        let width = view.frame.width
        
        var randomPositions = [CGPoint]()
        
        for _ in 0 ..<  colors.count * 2 {
            let randomX = CGFloat.random(in: 0 ..< width)
            let randomY = CGFloat.random(in: 0 ..< height)
            let p = CGPoint(x: randomX, y: randomY)
            randomPositions.append(p)
        }
        
        return randomPositions
    }
    
    func addBalls() {
        let positions = calculatePositions()
        var numberOfIterations = 0
        for i in 0 ..< colors.count * 2 {
            var newBall: CustomBall?
            
            if numberOfIterations < colors.count {
                newBall = createBall(position: positions[i], colors: colors[i])
            } else {
                newBall = createBall(position: positions[i], colors: colors[i - colors.count])
            }
            
            if let ball = newBall {
                balls.append(ball)
            }
            
            numberOfIterations += 1
        }
    }
    
    func createBall(position: CGPoint, colors: (UIColor, UIColor)) -> CustomBall {
        let ball = CustomBall(position: position, colors: colors)
        
        self.view.insertSubview(ball, at: 0)
        
        motionManager?.collider.addItem(ball)
        motionManager?.gravity.addItem(ball)
        
        return ball
    }
    
}

