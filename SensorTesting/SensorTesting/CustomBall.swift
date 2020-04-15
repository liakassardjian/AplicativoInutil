//
//  CustomSphere.swift
//  SensorTesting
//
//  Created by Lia Kassardjian on 15/04/20.
//  Copyright © 2020 Lia Kassardjian. All rights reserved.
//

import UIKit

class CustomBall: UIView {
    
    init(position: CGPoint, color: UIColor) {
        super.init(
            frame: CGRect(
                x: position.x,
                y: position.y,
                width: 60,
                height: 60
            )
        )
        self.layer.cornerRadius = self.frame.height/2
        self.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
