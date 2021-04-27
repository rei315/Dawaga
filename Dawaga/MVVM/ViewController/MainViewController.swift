//
//  MainViewController.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture
import SnapKit
import CoreLocation

class MainViewController: UIViewController {

    // MARK: - UI Initialization
    
    private lazy var searchView: MainViewSearchView = {
        let sv = MainViewSearchView()
        return sv
    }()
    
    private lazy var bookmarkTableView: UITableView = {
        let tv = UITableView()
        tv.register(BookMarkTableViewCell.self, forCellReuseIdentifier: BookMarkTableViewCell.self.identifier)
        tv.estimatedRowHeight = BookMarkTableViewCell.CELL_HEIGHT
        tv.separatorStyle = .none
        return tv
    }()
    
    
    // MARK: - Property
    
    private let disposeBag = DisposeBag()
    private let viewModel: MainViewModel!
    private let model: MainModel!
    
    // MARK: - Lifecycle
    
    init(model: MainModel, viewModel: MainViewModel) {
        self.model = model
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchView.endEditing(true)
        self.setupNavigationController()
        self.setupTutorialView()
        
        self.viewModel.fetchBookMarks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSearchView()
        self.setupView()
        self.setupBookmarkTableView()
        self.configureTableViewData()
    }
    
    // MARK: - Function

    private func setupTutorialView() {
        let isLaunchedBefore = UserDefaults.standard.bool(forKey: "LaunchedBefore")
        
        guard !isLaunchedBefore else { return }
        
        UserDefaults.standard.setValue(true, forKey: "LaunchedBefore")
        let tutorialVC = TutorialViewController()
        tutorialVC.modalPresentationStyle = .fullScreen
        self.present(tutorialVC, animated: true, completion: nil)
    }
            
    private func configureTableViewData() {
        viewModel.bookMarks
            .asDriver(onErrorJustReturn: [])
            .drive(bookmarkTableView.rx.items) { tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier: BookMarkTableViewCell.self.identifier) as? BookMarkTableViewCell
                cell?.configureItem(mark: data)
                return cell ?? UITableViewCell()
            }
            .disposed(by: disposeBag)
        
        Observable.zip(bookmarkTableView.rx.modelSelected(MarkRealmEntity.self), bookmarkTableView.rx.itemSelected)
            .do(onNext: { [weak self] (place, indexPath) in
                self?.view.endEditing(true)
                self?.bookmarkTableView.deselectRow(at: indexPath, animated: true)
            })
            .subscribe(onNext: { [unowned self] (mark, indexPath) in
                self.pushDawagaMapVC(bookMark: mark)
            })
            .disposed(by: disposeBag)
    }
    
    private func pushSearchVC(address: String?) {
        let model = PlaceSearchModel()
        let viewModel = PlaceSearchViewModel(model: model, address: address)
        let searchVC = PlaceSearchViewController(model: model, viewModel: viewModel)
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func pushDawagaMapVC(bookMark: MarkRealmEntity? = nil) {
        let model = DawagaMapModel()
        let viewModel = DawagaMapViewModel(model: model, transitionType: bookMark == nil ? .Quick : .BookMark, bookMark: bookMark)
        let dawagaMapVC = DawagaMapViewController(model: model, viewModel: viewModel)
        self.navigationController?.pushViewController(dawagaMapVC, animated: true)
    }
}


// MARK: - UI Setup
extension MainViewController {
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
    private func setupSearchView() {
        view.addSubview(searchView)
        
        searchView.quickMapButtonAction = {
            self.pushDawagaMapVC()
        }
        
        searchView.quickSearchButtonAction = { address in
            self.pushSearchVC(address: address)
        }
        
        searchView.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(MainViewSearchView.VIEW_HEIGHT)
        })
    }
    
    private func setupBookmarkTableView() {
        view.addSubview(bookmarkTableView)
        
        bookmarkTableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        bookmarkTableView.rx.swipeGesture(.down, .up)
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
                 
        bookmarkTableView.backgroundView = UIView()
        bookmarkTableView.backgroundView?.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        bookmarkTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookMarkTableViewCell.CELL_HEIGHT
    }
}

