//
//  RotationAnimation.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit

class RotationAnimation: CABasicAnimation {
    
    enum Direction: String {
        case x, y, z
    }
    
    override init() {
        super.init()
    }
    
    public init(direction: Direction, fromValue: CGFloat, toValue: CGFloat, duration: Double, repeatCount: Float) {
        super.init()
        
        self.keyPath = "transform.rotation.\(direction.rawValue)"
        
        self.fromValue = fromValue
        self.toValue = toValue
        
        self.duration = duration
        
        self.repeatCount = repeatCount
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
