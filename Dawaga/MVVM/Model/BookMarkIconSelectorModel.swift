//
//  BookMarkIconSelectorModel.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import RxSwift

struct BookMarkIconSelectorModel {
    
    func fetchIconTitles() -> Observable<[String]> {
        return ResourceManager.shared.fetchMarkIcons()
    }
}
