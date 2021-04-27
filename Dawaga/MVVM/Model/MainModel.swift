//
//  MainModel.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import RxSwift

struct MainModel {
    
    func fetchBookMarks() -> Observable<[MarkRealmEntity]> {
        return MarkRealm.getMarkRealmList()
    }
}
