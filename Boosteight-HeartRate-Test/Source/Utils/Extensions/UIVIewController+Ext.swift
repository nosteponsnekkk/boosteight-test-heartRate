//
//  UIVIewController+Ext.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import UIKit
extension UIViewController {
    func presentAlert(withTitle title: String? = nil,
                      withMessage message: String? = nil,
                      withCancelTitle cancelTitle: String = "Cancel",
                      withConfirmTitle confirmTitle: String = "Confirm",
                      action: @escaping () -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        ac.addAction(UIAlertAction(title: confirmTitle, style: .destructive, handler: { _ in
            action()
        }))
        present(ac, animated: true)
    }
}
