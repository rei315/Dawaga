//
//  PlaceSearchViewController.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture

class PlaceSearchViewController: UIViewController {

    // MARK: - UI Initialization
    
    private let searchView: PlaceSearchView = {
        let sv = PlaceSearchView()
        return sv
    }()
    
    private lazy var placeTableView: UITableView = {
        let tv = UITableView()
        tv.register(PlaceSearchTableViewCell.self, forCellReuseIdentifier: PlaceSearchTableViewCell.self.identifier)
        tv.estimatedRowHeight = PlaceSearchTableViewCell.CELL_HEIGHT
        return tv
    }()
    
    
    // MARK: - Property
    
    private let disposeBag = DisposeBag()
    private let viewModel: PlaceSearchViewModel!
    private let model: PlaceSearchModel!
    
    // MARK: - Lifecycle
    
    init(model: PlaceSearchModel, viewModel: PlaceSearchViewModel) {
        self.model = model
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
        
        self.setupNavigationController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSearchView()
        self.setupPlaceTableView()
        self.setupTableViewData()
    }
    
        
    // MARK: - Function
    
    private func pushDawagaMapVC(placeID: String?) {
        let model = DawagaMapModel()
        let viewModel = DawagaMapViewModel(model: model, transitionType: .Search, placeID: placeID)
        let dawagaMapVC = DawagaMapViewController(model: model, viewModel: viewModel)
        self.navigationController?.pushViewController(dawagaMapVC, animated: true)
    }
    
    private func setupTableViewData() {
        viewModel.searchedPlace
            .asDriver()
            .drive(placeTableView.rx.items) { tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier: PlaceSearchTableViewCell.self.identifier) as? PlaceSearchTableViewCell
                cell?.configurePlace(place: data)
                return cell ?? UITableViewCell()
            }
            .disposed(by: disposeBag)
        
        Observable.zip(placeTableView.rx.modelSelected(PlaceEntity.self), placeTableView.rx.itemSelected)
            .do(onNext: { [weak self] (place, indexPath) in
                self?.placeTableView.deselectRow(at: indexPath, animated: true)
            })
            .subscribe(onNext: { [unowned self] (place, indexPath) in
                self.pushDawagaMapVC(placeID: place.placeId)
            })
            .disposed(by: disposeBag)
            
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = NavigationTitle.DestinationAddress.localized()
        
        navigationController?.navigationBar
            .rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSearchView() {
        view.addSubview(searchView)
        
        searchView.searchButtonAction = { address in
            self.viewModel.searchText.accept(address)
        }
        
        searchView.configureItem(address: viewModel.searchText.value)
        
        searchView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(PlaceSearchView.VIEW_HEIGHT)
        }
    }
    
    private func setupPlaceTableView() {
        view.addSubview(placeTableView)
        
        placeTableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        placeTableView.rx.swipeGesture(.down, .up)
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)

        placeTableView.backgroundView = UIView()
        placeTableView.backgroundView?.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        placeTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
        }
    }
}

extension PlaceSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlaceSearchTableViewCell.CELL_HEIGHT
    }
}
