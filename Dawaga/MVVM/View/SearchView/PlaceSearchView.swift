//
//  PlaceSearchView.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit
import RxSwift

class PlaceSearchView: UIView {
    
    static let VIEW_HEIGHT: CGFloat = 70
    
    // MARK: - UI Initialization
    
    private lazy var addressField: UITextField = {
        let tf = PaddingTextField(padding: 10, type: .Delete)
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.attributedPlaceholder = NSAttributedString(string: AppString.AddressPlaceHolder.localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tf.clearButtonMode = .always
        tf.returnKeyType = .search
        tf.adjustsFontSizeToFitWidth = true
        return tf
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = .black
        return button
    }()
    
    private lazy var seperator: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .ultraLightGray
        return iv
    }()
    
    
    // MARK: - Property
    
    var searchButtonAction: ((String?) -> ())?
    
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
        self.setupSearchButtonView()
        self.configureTextFieldAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function

    func configureItem(address: String?) {
        addressField.text = address
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(addressField)
        addSubview(searchButton)
        addSubview(seperator)
        
        addressField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview()
            make.right.greaterThanOrEqualTo(searchButton.snp.left).offset(-20)
        }
                        
        searchButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(addressField)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        seperator.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    @objc private func onSearchButton(sender: UIButton) {
        searchButtonAction?(addressField.text)
        addressField.resignFirstResponder()
    }
    
    private func setupSearchButtonView() {
        searchButton.addTarget(self, action: #selector(onSearchButton(sender:)), for: .touchUpInside)
    }
    
    private func configureTextFieldAction() {
        addressField
            .rx.controlEvent([.editingDidEndOnExit])
            .subscribe(onNext: {
                self.searchButtonAction?(self.addressField.text)
            })
            .disposed(by: disposeBag)
    }
}
