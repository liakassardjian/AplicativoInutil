//
//  CustomSphere.swift
//  SensorTesting
//
//  Created by Lia Kassardjian on 15/04/20.
//  Copyright © 2020 Lia Kassardjian. All rights reserved.
//

import UIKit

let ballRadius: CGFloat = 30

class CustomBall: UIView {
    
    init(position: CGPoint, colors: (first: UIColor, second: UIColor)) {
        super.init(
            frame: CGRect(
                x: position.x,
                y: position.y,
                width: ballRadius * 2,
                height: ballRadius * 2
            )
        )

        self.layer.cornerRadius = self.frame.height/2
        self.setGradient(firstColor: colors.first, secondColor: colors.second)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGradient(firstColor: UIColor, secondColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = self.bounds
        gradient.cornerRadius = self.layer.cornerRadius
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    var shapeLayer: CAShapeLayer = {
        let _shapeLayer = CAShapeLayer()
        _shapeLayer.fillColor = UIColor.clear.cgColor
        return _shapeLayer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.addSublayer(shapeLayer)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.path = circularPath(center: center).cgPath
    }

    private func circularPath(lineWidth: CGFloat = 0, center: CGPoint = .zero) -> UIBezierPath {
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
    }

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType { return .path }

    override var collisionBoundingPath: UIBezierPath { return circularPath() }
    
}
