//
//  RoundButton.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit

class RoundButton: UIButton {
    
    private var cornerRadius: CGFloat = 0
    
    init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.roundCorner(corners: [.allCorners], radius: cornerRadius)
    }
}
