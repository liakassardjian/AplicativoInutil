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
    
    var ball:UIView?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        createBall()
        
        startDeviceMotion()
        createAnimator()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        motion.stopDeviceMotionUpdates()
    }
    
    func createBall() {
        let ball = UIView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 60, height: 60))
        ball.layer.cornerRadius = ball.frame.height/2
        ball.backgroundColor = UIColor.red
        
        self.view.insertSubview(ball, at: 0)
        self.ball = ball
    }
    
    func createAnimator() {
        animator = UIDynamicAnimator(referenceView: self.view);
        
        // Permite que a bola colida com objetos
        collider.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collider)
        
        // Permite que a bola apresente comportamento gravitacional
        animator?.addBehavior(gravity)
        
        if let ball = self.ball {
            collider.addItem(ball)
            gravity.addItem(ball)
        }
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
//                                    var p = CGPoint(x: x, y: y)
                                    
//                                    let orientation = UIApplication.shared.statusBarOrientation
//
//                                    if orientation == UIInterfaceOrientation.landscapeLeft {
//                                        let t = p.x
//                                        p.x = 0 - p.y
//                                        p.y = t
//                                    } else if orientation == UIInterfaceOrientation.landscapeRight {
//                                        let t = p.x
//                                        p.x = p.y
//                                        p.y = 0 - t
//                                    } else if orientation == UIInterfaceOrientation.portraitUpsideDown {
//                                        p.x *= -1
//                                        p.y *= -1
//                                    }
                                    
                                    let v = CGVector(dx: x, dy: -y)
                                    self.gravity.gravityDirection = v
                                }
            })
            
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        }
    }
    
}
