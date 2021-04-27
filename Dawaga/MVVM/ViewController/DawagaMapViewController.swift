//
//  DawagaMapViewController.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import GoogleMaps
import RxGoogleMaps

class DawagaMapViewController: UIViewController {

    enum TransitionType {
        case Search, Quick, BookMark
    }
    
    // MARK: - UI Initialization
    
    private lazy var mapView: GMSMapView = {
        let mapView = GMSMapView()
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        return mapView
    }()
    
    private let markSize = 35
    private let markImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "pin")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    private let bottomView: DawagaMapBottomView = {
        let bottomView = DawagaMapBottomView(cornerRadius: 12)
        return bottomView
    }()
    
    private var distanceEditView: DawagaMapEditView?
    
    private let loadingView: DawagaMapLoadingView = {
        let loadingView = DawagaMapLoadingView()
        loadingView.isUserInteractionEnabled = false
        loadingView.isLoading = false
        return loadingView
    }()
    
    // MARK: - Property
    
    private let disposeBag = DisposeBag()
    private let viewModel: DawagaMapViewModel!
    private let model: DawagaMapModel!
    
    private let zoomLevel: Float = 15.0
    
    private lazy var circle: GMSCircle = {
        let circle = GMSCircle()
        circle.fillColor = UIColor.red.withAlphaComponent(0.2)
        circle.strokeColor = UIColor.red
        circle.strokeWidth = 1
        return circle
    }()
    
    
    // MARK: - Lifecycle
    
    init(model: DawagaMapModel, viewModel: DawagaMapViewModel) {
        self.model = model
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setupMapView()
        self.setupBottomView()
        self.setupLoadingView()
        
        self.configureGMSMapView()
        self.configureViewModel()
    }

    
    // MARK: - Function

    private func configureViewModel() {
        
        mapView.rx.didStartTileRendering
            .take(1)
            .subscribe(onNext: { [weak self] in
                self?.loadingView.isLoading = true
            })
            .disposed(by: disposeBag)
        
        mapView.rx.didFinishTileRendering
            .take(1)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.configureState()
                
                let distance = self?.bottomView.distanceState.rawValue ?? DawagaMapBottomView.DistanceState.Fifty.rawValue
                self?.viewModel.curDistance.accept(distance)
                
                self?.loadingView.isLoading = false
            })
            .disposed(by: disposeBag)
        
        viewModel.authorization
            .subscribe(onNext: { state in
                switch state {
                case .denied, .restricted:
                    let action = UIAlertAction(title: AppString.Enter.localized(), style: .default) { _ in
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    }
                    self.showAlert(title: AppString.LocationDeniedTitle.localized(), message: AppString.LocationDeniedMessage.localized(), style: .alert, actions: [action])
                case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
                    break
                @unknown default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.didUpdateLocation
            .subscribe(onNext: { [unowned self] location in
                self.configureMapCenter(with: location)
            })
            .disposed(by: disposeBag)
        
        viewModel.didRegionChangedStr
            .bind(to: bottomView.regionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configureGMSMapView() {
        
        mapView.rx.idleAt
            .map { [weak self] _ in
                guard let target = self?.mapView.camera.target else { return CLLocation(latitude: 0, longitude: 0)}
                
                return CLLocation(latitude: target.latitude, longitude: target.longitude)
            }
            .bind(to: viewModel.didRegionChanged)
            .disposed(by: disposeBag)
        
        mapView.rx.idleAt.asDriver()
            .skip(1)
            .drive(onNext: { [unowned self] _ in
                let distance = self.viewModel.curDistance.value
                self.configureCircle(with: distance)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.curDistance
            .skip(1)
            .subscribe(onNext: { distance in
                self.configureCircle(with: distance)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureMapCenter(with location: CLLocation) {
        let region = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)

        self.mapView.camera = region
    }
    
    private func configureCircle(with radius: Int) {
        mapView.clear()
        
        let cllDistance = CLLocationDistance(radius)

        circle.position = self.mapView.camera.target
        circle.radius = cllDistance
        
        circle.map = mapView
    }
    
    private func presentBookMarkIconSelectorVC() {
        let model = BookMarkIconSelectorModel()
        let viewModel = BookMarkIconSelectorViewModel(model: model)
        let bookMarkIconSelectorVC = BookMarkIconSelectorViewController(model: model, viewModel: viewModel)
        bookMarkIconSelectorVC.delegate = self
        
        self.present(bookMarkIconSelectorVC, animated: true, completion: nil)
    }
}

// MARK: - UI Setup
extension DawagaMapViewController {
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        
        let mapInsets = UIEdgeInsets(top: 0, left: 0, bottom: DawagaMapBottomView.VIEW_HEIGHT*0.9, right: 0)
        mapView.padding = mapInsets
        mapView.addSubview(markImageView)
        mapView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        markImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-markSize-Int(DawagaMapBottomView.VIEW_HEIGHT)/4)
            make.width.equalTo(markSize)
            make.height.equalTo(markSize)
        }
    }
    
    private func setupBottomView() {
        
        bottomView.setupTransitionType(
            type: viewModel.transitionType,
            mark: viewModel.bookMark
        )
        
        bottomView.fiftyButtonAction = { distance in
            self.viewModel.curDistance.accept(distance)
        }
        
        bottomView.hundredButtonAction = { distance in
            self.viewModel.curDistance.accept(distance)
        }
        
        bottomView.thousandButtonAction = { distance in
            self.viewModel.curDistance.accept(distance)
        }
        
        bottomView.bookMarkIconButtonAction = {
            self.presentBookMarkIconSelectorVC()
        }
        
        bottomView.editViewAction = { state in
            switch state {
            case .BookMark:
                self.setupDistanceEditView(state: .BookMark)
            case .Distance:
                self.setupDistanceEditView(state: .Distance)
            case .None:
                break
            }
        }
        
        bottomView.startDawagaButtonAction = {
            let distance = self.viewModel.curDistance.value
            let coor = self.circle.position
            let destination = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
            
            let model = DawagaLoadingModel()
            let viewModel = DawagaLoadingViewModel(model: model, destination: destination, distance: distance)
            
            let dawagaLoadingVC = DawagaLoadingViewController(model: model, viewModel: viewModel)
            self.navigationController?.pushViewController(dawagaLoadingVC, animated: true)
        }
        
        bottomView.saveBookMarkButtonAction = { data in
            let title = data.title
            let icon = data.markIcon
            let address = data.address
            let location = self.circle.position
            
            guard self.checkMarkRealmTitleAvailable(title: title) else {
                let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkNameEmptyAlertMessage.localized(), style: .alert, actions: [action])
                return
            }
            guard self.checkMarkRealmIconAvailable(icon: icon) else {
                let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkImageEmptyAlertMessage.localized(), style: .alert, actions: [action])
                return
            }
            
            let realmMark = MarkRealmEntity(identity: "\(Date())", name: title, latitude: location.latitude, longitude: location.longitude, address: address, iconImageUrl: icon)
                        
            self.model.saveBookMark(mark: realmMark)
                .subscribe(onNext: {
                    let action = UIAlertAction(title: AppString.Enter.localized(), style: .default) { _ in
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    }
                    self.showAlert(title: AppString.CreatedComplete.localized(), message: AppString.BookMarkCreated.localized(), style: .alert, actions: [action])
                }, onError: { _ in
                    let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                    self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkRealmErrorAlertMessage.localized(), style: .alert, actions: [action])
                })
                .disposed(by: self.disposeBag)
        }
        
        bottomView.editBookMarkButtonAction = { data in
            let title = data.title
            let icon = data.markIcon
            let address = data.address
            
            let location = self.circle.position
            let lat: Double = location.latitude
            let lng: Double = location.longitude
            
            guard let identity = self.viewModel.bookMark?.identity else { return }
            
            guard self.checkMarkRealmTitleAvailable(title: title) else {
                let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkNameEmptyAlertMessage.localized(), style: .alert, actions: [action])
                return
            }
            guard self.checkMarkRealmIconAvailable(icon: icon) else {
                let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkImageEmptyAlertMessage.localized(), style: .alert, actions: [action])
                return
            }
            
            
            self.model.editBookMark(identity: identity, name: title, address: address, iconImage: icon, latitude: lat, longitude: lng)
                .subscribe(onNext: {
                    let action = UIAlertAction(title: AppString.Enter.localized(), style: .default) { _ in
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    }
                    self.showAlert(title: AppString.UpdateComplete.localized(), message: AppString.BookMarkUpdated.localized(), style: .alert, actions: [action])
                }, onError: { _ in
                    let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                    self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkRealmErrorAlertMessage.localized(), style: .alert, actions: [action])
                })
                .disposed(by: self.disposeBag)
        }
        
        bottomView.deleteBookMarkButtonAction = {
            guard let identity = self.viewModel.bookMark?.identity else { return }
            
            self.model.removeBookMark(identity: identity)
                .subscribe(onNext: {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                }, onError: { _ in
                    let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                    self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkRealmErrorAlertMessage.localized(), style: .alert, actions: [action])
                })
                .disposed(by: self.disposeBag)
        }
        
        view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(view.frame.height-DawagaMapBottomView.VIEW_HEIGHT)
        }
    }
    
    private func checkMarkRealmTitleAvailable(title: String) -> Bool {
        if title.isEmpty { return false }
                
        return true
    }
    private func checkMarkRealmIconAvailable(icon: String) -> Bool {
        if icon.isEmpty { return false }
        return true
    }
    
    private func setupDistanceEditView(state: DawagaMapBottomView.EditState) {
        guard distanceEditView == nil else { return }
        
        self.distanceEditView = DawagaMapEditView(state: state)
        if let view = self.distanceEditView {
            self.view.addSubview(view)
        }
        
        distanceEditView?.enterDistanceButtonAction = { value in
            self.viewModel.curDistance.accept(value)
            
            self.distanceEditView?.removeFromSuperview()
            self.distanceEditView = nil
        }
        
        distanceEditView?.enterBookMarkButtonAction = { title in
            self.bottomView.configureBookMarkField(title: title)
            self.distanceEditView?.removeFromSuperview()
            self.distanceEditView = nil
        }
        
        distanceEditView?.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.topItem?.title = ""
    }
}

extension DawagaMapViewController: BookMarkIconSelectorDelegate {
    func didIconSelected(imageName: String, icon: UIImage) {
        bottomView.setupBookMarkIcon(imageName: imageName, image: icon)
    }
}
