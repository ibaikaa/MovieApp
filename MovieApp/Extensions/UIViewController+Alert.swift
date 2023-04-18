//
//  UIViewController+Alert.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import UIKit

extension UIViewController {
    /// Метод для удобного создания алерта. 
    func showInfoAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Ok",
                style: .default
            )
        )
        
        present(alert, animated: true)
    }
}
