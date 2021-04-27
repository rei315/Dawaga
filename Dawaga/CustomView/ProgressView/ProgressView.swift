//
//  ProgressView.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit

class ProgressView: UIView {
    
    // MARK: - Property
    
    private lazy var shapeLayer: ProgressShapeLayer = {
        return ProgressShapeLayer(strokeColor: colors.first!, lineWidth: lineWidth)
    }()
    
    let colors: [UIColor]
    let lineWidth: CGFloat
            
    var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                self.animateStroke()
                self.animateRotation()
            } else {
                self.shapeLayer.removeFromSuperlayer()
                self.layer.removeAllAnimations()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, colors: [UIColor], lineWidth: CGFloat) {
        self.colors = colors
        self.lineWidth = lineWidth
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    convenience init(colors: [UIColor], lineWidth: CGFloat) {
        self.init(frame: .zero, colors: colors, lineWidth: lineWidth)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.width / 2
        
        // 3
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width))
        
        shapeLayer.path = path.cgPath
    }
        
    
    // MARK: - Function
    
    func animateStroke() {
            
            let startAnimation = StrokeAnimation(
                type: .start,
                beginTime: 0.25,
                fromValue: 0.0,
                toValue: 1.0,
                duration: 0.75
            )
            
            let endAnimation = StrokeAnimation(
                type: .end,
                fromValue: 0.0,
                toValue: 1.0,
                duration: 0.75
            )
            
            let strokeAnimationGroup = CAAnimationGroup()
            strokeAnimationGroup.duration = 1
            strokeAnimationGroup.repeatDuration = .infinity
            strokeAnimationGroup.animations = [startAnimation, endAnimation]
            
            shapeLayer.add(strokeAnimationGroup, forKey: nil)
            
            self.layer.addSublayer(shapeLayer)
        }
    
    func animateRotation() {
            let rotationAnimation = RotationAnimation(
                direction: .z,
                fromValue: 0,
                toValue: CGFloat.pi * 2,
                duration: 2,
                repeatCount: .greatestFiniteMagnitude
            )
            
            self.layer.add(rotationAnimation, forKey: nil)
        }
}
