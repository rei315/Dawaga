//
//  DawagaMapEditView.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit
import SnapKit

class DawagaMapEditView: UIView {

    // MARK: - UI Initialization
    
    private let valueEditDimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return view
    }()
    
    private let valueTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 50)
        tf.textColor = .white
        tf.attributedPlaceholder = NSAttributedString(string: AppString.DawagaMapEditViewPlaceHolder.localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 50)])
        tf.textAlignment = .center
        tf.borderStyle = .none
        tf.returnKeyType = .done
        tf.doneAccessory = true
        return tf
    }()
    
    private lazy var valueEditEnterButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = ValueEditButtonsWidth / 2
        bt.layer.borderColor = UIColor.middleBlue.cgColor
        bt.layer.borderWidth = 5
        bt.backgroundColor = .clear
        bt.setTitle(AppString.Enter.localized(), for: .normal)
        bt.setTitleColor(.middleBlue, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return bt
    }()
    
    
    // MARK: - Property
    
    private let ValueEditButtonsWidth = DeviceSize.screenWidth()/5
    private let ValueEditButtonsTop = 250
    private let ValueTextFieldTop = 100
    private let meter = " m"
    
    private var editState: DawagaMapBottomView.EditState = .None
    
    var enterDistanceButtonAction: ((Int) -> ())?
    var enterBookMarkButtonAction: ((String) -> ())?
    
    
    // MARK: - Lifecycle
    
    init(state: DawagaMapBottomView.EditState) {
        super.init(frame: .zero)
        
        self.editState = state
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.openKeyboard()
    }
    
    
    // MARK: - Function
    
    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
    
    private func openKeyboard() {
        self.valueTextField.becomeFirstResponder()
    }
}


// MARK: - Button Actions
extension DawagaMapEditView {
    
    @objc private func onValueEditEnterButton() {
        switch self.editState {
        case .Distance:
            self.enterDistanceButtonAction?(self.convertValue(toInt: self.valueTextField.text))
        case .BookMark:
            self.enterBookMarkButtonAction?(self.valueTextField.text ?? "")
        case .None:
            break
        }
    }
}


// MARK: - Helpers
extension DawagaMapEditView {
    
    private func convertValue(toInt value: String?) -> Int {
        guard var text = value else { return 0 }
        
        if text.contains(meter) {
            text = text.replacingOccurrences(of: meter, with: "")
        }
        
        let filterStr = text.filter { $0.isNumber }
        if let valueInt = Int(filterStr) {
            return valueInt
        }
        
        return 0
    }
}


// MARK: - TextField Delegate
extension DawagaMapEditView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch self.editState {
        case .Distance:
            return self.textLimit(existingText: textField.text, newText: string, limit: 5)
        case .BookMark:
            return self.textLimit(existingText: textField.text, newText: string, limit: 10)
        case .None:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard self.editState == .Distance else { return true }
        guard let text = valueTextField.text else { return true }
        if !text.contains(meter) {
            valueTextField.text = (text.isEmpty ? "0" : text) + meter
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard self.editState == .Distance else { return true }
        guard let text = valueTextField.text else { return true }
        
        if text.contains(meter) {
            valueTextField.text = text.replacingOccurrences(of: meter, with: "")
        }
        if text == "0" + meter {
            valueTextField.text = ""
        }
        
        return true
    }
    
    @objc private func valueTextFieldChanged() {
        guard let text = valueTextField.text else { return }
        
        if text.contains(meter) {
            valueTextField.text = text.replacingOccurrences(of: meter, with: "")
        }
    }
}


// MARK: - UI
extension DawagaMapEditView {
    
    private func setupUI() {
        self.addSubview(valueEditDimView)
        valueEditDimView.addSubview(valueEditEnterButton)
        valueEditDimView.addSubview(valueTextField)
                        
        valueTextField.delegate = self
        
        switch self.editState {
        case .Distance:
            valueTextField.keyboardType = .numberPad
        case .BookMark, .None:
            valueTextField.keyboardType = .default
        }
        
        if self.editState == .Distance {
            valueTextField.addTarget(self, action: #selector(valueTextFieldChanged), for: .editingChanged)
        }
        
        valueEditDimView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        valueEditEnterButton.addTarget(self, action: #selector(onValueEditEnterButton), for: .touchUpInside)
        
        valueTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-ValueTextFieldTop)
        }
                        
        valueEditEnterButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(ValueEditButtonsWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(valueTextField.snp.bottom).offset(ValueEditButtonsTop)
        }
    }
}
