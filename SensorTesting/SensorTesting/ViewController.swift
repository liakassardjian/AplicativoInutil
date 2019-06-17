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

    let motion = CMMotionManager()
    
    var animator:UIDynamicAnimator? = nil
    let gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()
    
    var balls:[UIView] = []
    
    let colors = [#colorLiteral(red: 1, green: 0.1367589235, blue: 0.2771877348, alpha: 1),#colorLiteral(red: 0.7035043312, green: 0.4171022667, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0.5980905911, blue: 0.3536005144, alpha: 1),#colorLiteral(red: 0.4720113319, green: 1, blue: 0.5710921309, alpha: 1),#colorLiteral(red: 0.2889700684, green: 0.8908427892, blue: 1, alpha: 1)]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        addBalls()
        
        startDeviceMotion()
        createAnimator()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        motion.stopDeviceMotionUpdates()
    }
    
    func addBalls() {
        var distance:Int = 0
        var viewX:Int = 0
        if let view = self.view {
            distance = Int(view.frame.height) / colors.count
            viewX = Int(view.center.x)
        }
        
        var lastY:Int = 0
        for i in colors {
            let p = CGPoint(x: viewX, y: lastY)
            balls.append(createBall(position: p, color: i))
            lastY += distance
        }
    }
    
    func createBall(position: CGPoint, color: UIColor) -> UIView {
        let ball = UIView(frame: CGRect(x: position.x, y: position.y, width: 60, height: 60))
        ball.layer.cornerRadius = ball.frame.height/2
        ball.backgroundColor = color
        
        self.view.insertSubview(ball, at: 0)
        
        collider.addItem(ball)
        gravity.addItem(ball)
        
        return ball
    }
    
    func createAnimator() {
        animator = UIDynamicAnimator(referenceView: self.view);
        
        // Permite que as bolas colidam com objetos
        collider.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collider)
        
        // Permite que as bolas apresentem comportamento gravitacional
        animator?.addBehavior(gravity)
    }

    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            //Frequencia de atualização dos sensores definida em segundos - no caso, 60 vezes por segundo
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            //A partir da chamada desta função, o objeto motion passa a conter valores atualizados dos sensores; o parâmetro representa a referência para cálculo de orientação do dispositivo
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            //Um Timer é configurado para executar um bloco de código 60 vezes por segundo - a mesma frequência das atualizações dos dados de sensores. Neste bloco manipulamos as informações mais recentes para atualizar a interface.
            let timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true,
                              block: { (timer) in
                                if let data = self.motion.deviceMotion {
                                    let grav = data.gravity
                            
                                    let x = CGFloat(grav.x)
                                    let y = CGFloat(grav.y)
//
                                    let v = CGVector(dx: x, dy: -y)
                                    self.gravity.gravityDirection = v
                                }
            })
            
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        }
    }
    
}

