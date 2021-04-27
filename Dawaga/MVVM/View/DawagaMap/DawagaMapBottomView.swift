//
//  DawagaMapBottomView.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit

class DawagaMapBottomView: CornerView {
    
    static let VIEW_HEIGHT: CGFloat = 220
        
    // MARK: - UI Initialization
    
    let regionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let distanceFiftyButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 5
        bt.backgroundColor = .lightGray
        bt.setTitle(AppString.Fifty.localized(), for: .normal)
        return bt
    }()
    
    private let distanceHundredButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 5
        bt.backgroundColor = .lightGray
        bt.setTitle(AppString.Hundred.localized(), for: .normal)
        return bt
    }()
    
    private let distanceThousandButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 5
        bt.backgroundColor = .lightGray
        bt.setTitle(AppString.Thousand.localized(), for: .normal)
        return bt
    }()
    
    private let distanceEditButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 5
        bt.backgroundColor = .lightGray
        bt.setTitle(AppString.DistanceEdit.localized(), for: .normal)
        return bt
    }()
    
    private let bookMarkButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 8
        bt.backgroundColor = .middleBlue
        bt.setImage(UIImage(systemName: "star"), for: .normal)
        bt.tintColor = .white
        return bt
    }()
    
    private let startButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 8
        bt.backgroundColor = .middleBlue
        bt.setTitle(AppString.DawagaMapStart.localized(), for: .normal)
        return bt
    }()
    
    private let bookMarkField: PaddingTextField = {
        let tf = PaddingTextField(padding: 10, type: .Default)
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.attributedPlaceholder = NSAttributedString(string: AppString.DawagaMapEditValuePlaceHolder.localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tf.layer.borderColor = UIColor.middleBlue.cgColor
        tf.layer.borderWidth = 1.5
        tf.layer.cornerRadius = 4.0
        tf.allowsEditingTextAttributes = false
        tf.textAlignment = .center
        tf.adjustsFontSizeToFitWidth = true
        return tf
    }()
    
    private let bookMarkView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }()
    
    private let bookMarkIconButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 8
        bt.backgroundColor = .lightGray
        bt.setImage(UIImage(systemName: "plus"), for: .normal)
        bt.tintColor = .white
        return bt
    }()
    
    private let bookMarkCreateButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 8
        bt.backgroundColor = .middleBlue
        bt.setTitle(AppString.DawagaMapAddBookMark.localized(), for: .normal)
        bt.tintColor = .white
        return bt
    }()
    
    private let bookMarkDeleteButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 8
        bt.backgroundColor = .middleBlue
        bt.setImage(UIImage(systemName: "trash"), for: .normal)
        bt.tintColor = .white
        return bt
    }()
    
    // MARK: - Property
    
    enum EditViewState { case On, Off }
    enum EditState { case Distance, BookMark, None }
    enum DistanceState: Int{
        case Fifty = 50
        case Hundred = 100
        case Thousand = 1000
        case EditValue = 0
    }
    
    private var editViewState: EditViewState = .Off
    private var editState: EditState = .None
    
    var distanceState: DistanceState = .Fifty
    
    var fiftyButtonAction: ((Int) -> ())?
    var hundredButtonAction: ((Int) -> ())?
    var thousandButtonAction: ((Int) -> ())?
    
    var bookMarkIconButtonAction: (() -> ())?
    
    var saveBookMarkButtonAction: ((BookMarkData) -> ())?
    var editBookMarkButtonAction: ((BookMarkData) -> ())?
    var deleteBookMarkButtonAction: (() -> ())?
    
    var startDawagaButtonAction: (() -> ())?
    
    var editViewAction: ((EditState) -> ())?
    
    private var transitionType: DawagaMapViewController.TransitionType = .Quick
    
    private var mark: MarkRealmEntity?
    
    private var iconName: String? = nil
    
    struct BookMarkData {
        let title: String
        let markIcon: String
        let address: String
    }
    
    
    // MARK: - Lifecycle
    
    override init(cornerRadius: CGFloat) {
        super.init(cornerRadius: cornerRadius)
        self.backgroundColor = .lightBlue
        
        setupBottomView()
        setupDistanceButtonViews()
        setupBookMarkTitleFieldView()
        
        onFiftyButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function

    func setupTransitionType(type: DawagaMapViewController.TransitionType, mark: MarkRealmEntity? = nil) {
        self.transitionType = type
        self.mark = mark
    }
    
    func configureRegionField(address: String) {
        self.regionLabel.text = address
    }
    
    func configureBookMarkField(title: String) {
        self.bookMarkField.text = title
    }
}

// MARK: - Button Action

extension DawagaMapBottomView {
    
    // MARK: - Distance Edit
    
    @objc private func onFiftyButton() {
        resetDistanceButtonConfigure()
        self.distanceState = .Fifty
        self.distanceFiftyButton.backgroundColor = .red
        self.fiftyButtonAction?(self.distanceState.rawValue)
    }
    
    @objc private func onHundredButton() {
        resetDistanceButtonConfigure()
        self.distanceState = .Hundred
        self.distanceHundredButton.backgroundColor = .red
        self.hundredButtonAction?(self.distanceState.rawValue)
    }
    
    @objc private func onThousandButton() {
        resetDistanceButtonConfigure()
        self.distanceState = .Thousand
        self.distanceThousandButton.backgroundColor = .red
        self.thousandButtonAction?(self.distanceState.rawValue)
    }
    
    @objc private func onEditButton() {
        if self.editViewState == .On {
            onEditBookMark()
        }
        resetDistanceButtonConfigure()
        self.distanceState = .EditValue
        self.editState = .Distance
        self.distanceEditButton.backgroundColor = .red
        editViewAction?(.Distance)
    }
    
    
    // MARK: - BookMark Edit
    @objc private func onBookMarkField() {
        self.editState = .BookMark
        editViewAction?(.BookMark)
    }
    
    @objc private func onBookMarkIconButton() {
        self.bookMarkIconButtonAction?()
    }
    
    @objc private func onEditBookMark() {
        switch (editViewState) {
        case .On:
            self.editViewState = .Off
            self.editOffBookMark()
                        
        case .Off:
            self.editViewState = .On
            self.editState = .BookMark
            self.editOnBookMark()
        }
    }
    
    @objc private func onSaveBookMarkButton() {
        let title = self.bookMarkField.text ?? ""
        let markIcon = self.iconName ?? ""
        let region = regionLabel.text ?? ""
        
        let data = BookMarkData(title: title, markIcon: markIcon, address: region)
        self.saveBookMarkButtonAction?(data)
    }
    
    @objc private func onEditBookMarkButton() {
        let title = self.bookMarkField.text ?? ""
        
        let markIcon = self.iconName ?? ""
        let region = regionLabel.text ?? ""
        
        let data = BookMarkData(title: title, markIcon: markIcon, address: region)
        self.editBookMarkButtonAction?(data)
    }
    
    @objc private func onDeleteBookMarkButton() {
        self.deleteBookMarkButtonAction?()
    }
    
    
    // MARK: - Start
    @objc private func onStartDawagaButton() {
        self.startDawagaButtonAction?()
    }
}


// MARK: - Helpers

extension DawagaMapBottomView {
    
    private func getValueFromField(valueStr: String) -> Int {
        let filterStr = valueStr.filter { $0.isNumber }
        if let valueInt = Int(filterStr) {
            return valueInt
        }
        return 0
    }
}

// MARK: - UI

extension DawagaMapBottomView {
    
    private func setupDistanceButtonViews() {
        self.distanceFiftyButton.addTarget(self, action: #selector(onFiftyButton), for: .touchUpInside)
        
        self.distanceHundredButton.addTarget(self, action: #selector(onHundredButton), for: .touchUpInside)
        
        self.distanceThousandButton.addTarget(self, action: #selector(onThousandButton), for: .touchUpInside)
        
        self.distanceEditButton.addTarget(self, action: #selector(onEditButton), for: .touchUpInside)
    }
    
    private func setupBookMarkTitleFieldView() {
        self.bookMarkField.addTarget(self, action: #selector(onBookMarkField), for: .editingDidBegin)
    }
    
    private func resetDistanceButtonConfigure() {
        switch self.distanceState {
        case .Fifty:
            distanceFiftyButton.backgroundColor = .lightGray
        case .Hundred:
            distanceHundredButton.backgroundColor = .lightGray
        case .Thousand:
            distanceThousandButton.backgroundColor = .lightGray
        case .EditValue:
            distanceEditButton.backgroundColor = .lightGray
        }
    }
    
    private func setupBottomView() {
        let topStack = UIStackView(arrangedSubviews: [distanceFiftyButton,
                                                   distanceHundredButton,
                                                   distanceThousandButton,
                                                   distanceEditButton])
        topStack.axis = .horizontal
        topStack.spacing = 10
        topStack.distribution = .fillEqually
                
        
        self.addSubview(topStack)
        
        self.addSubview(regionLabel)
        self.addSubview(bookMarkButton)
        self.addSubview(startButton)

        startButton.addTarget(self, action: #selector(onStartDawagaButton), for: .touchUpInside)
        
        bookMarkButton.addTarget(self, action: #selector(onEditBookMark), for: .touchUpInside)
        
        bookMarkIconButton.addTarget(self, action: #selector(onBookMarkIconButton), for: .touchUpInside)
        
        topStack.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }
        
        regionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topStack.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        startButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(regionLabel.snp.bottom).offset(20)
            make.height.equalTo(DawagaMapBottomView.VIEW_HEIGHT/4)
            make.width.equalTo(DeviceSize.screenWidth()-110)
        }
        
        bookMarkButton.snp.makeConstraints { (make) in
            make.left.equalTo(startButton.snp.right).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(startButton.snp.centerY)
            make.height.equalTo(startButton.snp.height)
        }
    }
    
    func setupBookMarkIcon(imageName: String, image: UIImage) {
        self.iconName = imageName
        
        bookMarkIconButton.backgroundColor = .clear
        bookMarkIconButton.layer.borderColor = UIColor.lightGray.cgColor
        bookMarkIconButton.layer.borderWidth = 1.5
        bookMarkIconButton.layer.cornerRadius = 8
        bookMarkIconButton.contentVerticalAlignment = .fill
        bookMarkIconButton.contentHorizontalAlignment = .fill
        bookMarkIconButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        bookMarkIconButton.setImage(image, for: .normal)
    }
}


// MARK: - Animation

extension DawagaMapBottomView {
    
    private func editOnBookMark() {
        self.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(DeviceSize.screenHeight()-(DawagaMapBottomView.VIEW_HEIGHT*2.5))
            make.bottom.equalToSuperview()
        }
        startButton.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.width.equalTo(0)
        }

        UIView.animate(withDuration: 0.5) {
            self.superview?.layoutIfNeeded()
        }
        
        bookMarkButton.setTitle(AppString.DawagaMapDeleteBookMark.localized(), for: .normal)
        bookMarkButton.backgroundColor = .middlePink
            
        bookMarkView.addSubview(bookMarkField)
        bookMarkView.addSubview(bookMarkCreateButton)
        bookMarkView.addSubview(bookMarkIconButton)
        
        self.addSubview(bookMarkView)
        
        bookMarkView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-40)
            make.top.equalTo(startButton.snp.bottom).offset(40)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        bookMarkField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(bookMarkIconButton.snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        bookMarkIconButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(bookMarkIconButton.snp.width)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.top.equalToSuperview()
        }
        
        if self.transitionType == .BookMark {
                        
            guard let mark = mark else { return }
            
            bookMarkField.text = mark.name
            
            let image = ResourceManager.shared.loadImageWithFileName(fileName: mark.iconImageUrl)
            setupBookMarkIcon(imageName: mark.iconImageUrl, image: image)
            
            bookMarkView.addSubview(bookMarkDeleteButton)
            
            bookMarkCreateButton.setTitle(AppString.DawagaMapModifyBookMark.localized(), for: .normal)
            bookMarkCreateButton.addTarget(self, action: #selector(onEditBookMarkButton), for: .touchUpInside)
            
            bookMarkDeleteButton.addTarget(self, action: #selector(onDeleteBookMarkButton), for: .touchUpInside)
            
            bookMarkCreateButton.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(20)
                make.height.equalTo(startButton.snp.height)
                make.width.equalToSuperview().multipliedBy(0.7)
                make.bottom.equalToSuperview()
            }
            
            bookMarkDeleteButton.snp.makeConstraints { (make) in
                make.left.equalTo(bookMarkCreateButton.snp.right).offset(20)
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(bookMarkCreateButton.snp.centerY)
                make.height.equalTo(bookMarkCreateButton.snp.height)
            }
        } else {
            
            bookMarkCreateButton.addTarget(self, action: #selector(onSaveBookMarkButton), for: .touchUpInside)
            
            bookMarkCreateButton.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.height.equalTo(startButton.snp.height)
                make.width.equalToSuperview().multipliedBy(0.8)
                make.bottom.equalToSuperview()
            }
        }
    }
    
    private func editOffBookMark() {
        
        self.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(DeviceSize.screenHeight()-DawagaMapBottomView.VIEW_HEIGHT)
            make.top.equalToSuperview().offset(DeviceSize.screenHeight()-DawagaMapBottomView.VIEW_HEIGHT)
        }
        
        startButton.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(DeviceSize.screenWidth()-110)
        }
                        
        UIView.animate(withDuration: 0.5) {
            self.superview?.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.5) {
            self.superview?.layoutIfNeeded()
        }
        
        bookMarkButton.setTitle("", for: .normal)
        bookMarkButton.backgroundColor = .middleBlue
        
        bookMarkView.removeFromSuperview()
    }
}
