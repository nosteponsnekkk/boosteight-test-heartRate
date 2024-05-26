//
//  BottomContainerView.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 22.05.2024.
//

import UIKit

public final class BottomContainerView: UIView {
    
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
      
        let path = UIBezierPath()
        
        path.move(to: .init(x: 0, y: 0))
        path.addQuadCurve(to: .init(x: rect.maxX, y: 0), controlPoint: .init(x: rect.midX, y: rect.midY * 0.8))
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        path.addLine(to: .init(x: 0, y: rect.maxY))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        layer.mask = shapeLayer
        
        UIColor.darkenWhite.setFill()
        path.fill()
        
    }
    
}
