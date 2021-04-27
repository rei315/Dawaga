//
//  String+Extension.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: "\(self)", comment: "")
    }
}
