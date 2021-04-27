//
//  PaddingTextField.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit

class PaddingTextField: UITextField {
    
    // MARK: - Property
    
    enum TextFieldType: CGFloat {
        case Default = 2
        case Delete = 5
    }
    
    @IBInspectable var padding: CGFloat = 0
    
    var textFieldType = TextFieldType.Default
    
    // MARK: - Lifecycle
    
    init(padding: CGFloat, type: TextFieldType) {
        self.padding = padding
        self.textFieldType = type
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width - padding * textFieldType.rawValue, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width - padding * textFieldType.rawValue, height: bounds.height)
    }
}
