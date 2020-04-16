//
//  CustomSphere.swift
//  SensorTesting
//
//  Created by Lia Kassardjian on 15/04/20.
//  Copyright © 2020 Lia Kassardjian. All rights reserved.
//

import UIKit

class CustomBall: UIView {
    
    var gradient: CAGradientLayer
    
    init(position: CGPoint, colors: (first: UIColor, second: UIColor)) {
        self.gradient = CAGradientLayer()
        
        super.init(
            frame: CGRect(
                x: position.x,
                y: position.y,
                width: 60,
                height: 60
            )
        )
        
        self.layer.cornerRadius = self.frame.height/2
        setGradient(firstColor: colors.first, secondColor: colors.second)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGradient(firstColor: UIColor, secondColor: UIColor) {
        gradient.colors = [firstColor, secondColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = self.bounds
        gradient.cornerRadius = self.layer.cornerRadius
    }
}
