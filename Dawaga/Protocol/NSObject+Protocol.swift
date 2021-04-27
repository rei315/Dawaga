//
//  NSObject+Protocol.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import Foundation

extension NSObjectProtocol {

    static var className: String {
        return String(describing: self)
    }
}
