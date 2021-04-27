//
//  PlaceSearchTableViewCell.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit

class PlaceSearchTableViewCell: UITableViewCell {

    static let CELL_HEIGHT: CGFloat = 70.0
    
    
    // MARK: - UI Initialization
    
    private let buildingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var searchImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "magnifyingglass")
        return iv
    }()
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure UI
    
    func configurePlace(place: PlaceEntity) {
        buildingLabel.text = place.placeName
    }
    
    private func configureCell() {
        addSubview(buildingLabel)
        addSubview(searchImage)
        
        buildingLabel.snp.makeConstraints { (make) in
            make.left.equalTo(searchImage.snp.right).offset(15)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        searchImage.snp.makeConstraints { (make) in
            make.height.equalTo(frame.height/2)
            make.width.equalTo(searchImage.snp.height)
            make.centerY.equalTo(buildingLabel.snp.centerY)
            make.left.equalToSuperview().offset(15)
        }
    }
}
