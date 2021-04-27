//
//  BookMarkIconSelectorViewController.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias BookMarkIconSectionModel = SectionModel<BookMarkIconSection, BookMarkIconSectionItem>

enum BookMarkIconSection {
    case icon
}

enum BookMarkIconSectionItem {
    case icon(iconURL: String)
}

protocol BookMarkIconSelectorDelegate: class {
    func didIconSelected(imageName: String, icon: UIImage)
}

class BookMarkIconSelectorViewController: UIViewController {

    // MARK: - UI Initialization
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(BookMarkIconCell.self, forCellWithReuseIdentifier: BookMarkIconCell.self.identifier)
        return cv
    }()
    
    
    // MARK: - Property
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<BookMarkIconSectionModel>(configureCell: configureCell)
    
    private lazy var configureCell: RxCollectionViewSectionedReloadDataSource<BookMarkIconSectionModel>.ConfigureCell = { [weak self] (_, cv, ip, item) in
        guard let strongSelf = self else { return UICollectionViewCell() }
        switch item {
        case .icon(let iconURL):
            return strongSelf.bookMarkIconCell(indexPath: ip, iconURL: iconURL)
        }
    }
    
    private let disposeBag = DisposeBag()
    private let model: BookMarkIconSelectorModel!
    private let viewModel: BookMarkIconSelectorViewModel!
    
    weak var delegate: BookMarkIconSelectorDelegate?
    
    // MARK: - Lifecycle
    
    init(model: BookMarkIconSelectorModel, viewModel: BookMarkIconSelectorViewModel) {
        self.model = model
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupCollectionView()
        self.configureCollectionViewData()
    }
    
    
    // MARK: - Function

    private func bookMarkIconCell(indexPath: IndexPath, iconURL: String) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookMarkIconCell.self.identifier, for: indexPath) as? BookMarkIconCell{
            cell.configureItem(iconUrl: iconURL)
            return cell
        }
        return UICollectionViewCell()
    }
    
    private func configureCollectionViewData() {
        viewModel.iconTitles
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(BookMarkIconSectionItem.self))
            .do(onNext: { [unowned self] (indexPath, icon) in
                self.collectionView.deselectItem(at: indexPath, animated: true)
            })
            .subscribe(onNext: { (indexPath, icon) in
                switch icon {
                case .icon(let iconURL):
                    let icon = ResourceManager.shared.getImageFromURL(str: iconURL)
                    let iconName = ResourceManager.shared.getFileName(fullURL: iconURL)
                    
                    self.delegate?.didIconSelected(imageName: iconName, icon: icon)
                    
                    self.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        
        collectionView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
            
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}

extension BookMarkIconSelectorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGFloat = DeviceSize.screenWidth() / 5
        return CGSize(width: cellSize, height: cellSize)
    }
}
