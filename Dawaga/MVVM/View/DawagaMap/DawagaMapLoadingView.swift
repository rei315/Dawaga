//
//  DawagaMapLoadingView.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit
import SnapKit

class DawagaMapLoadingView: UIView {

    // MARK: - UI Initialization

    private let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.middleBlue], lineWidth: 5)
        return progress
    }()
    
    
    // MARK: - Property
    
    var isLoading: Bool = true {
        didSet {
            if isLoading {
                startLoading()
            } else {
                stopLoading()
            }
        }
    }
    
    
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function

    private func startLoading() {
        isHidden = false
        loadingIndicator.isAnimating = true
    }
    
    private func stopLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.loadingIndicator.isAnimating = false
            self.isHidden = true
        }
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.addSubview(loadingIndicator)
        
        loadingIndicator.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
}
