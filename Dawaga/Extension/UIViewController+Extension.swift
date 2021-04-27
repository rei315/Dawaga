//
//  UIViewController+Extension.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction])
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
