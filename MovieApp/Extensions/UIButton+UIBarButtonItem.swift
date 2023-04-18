//
//  UIButton+UIBarButtonItem.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import UIKit

extension UIButton {
    func toBarButtonItem() -> UIBarButtonItem? {
        return UIBarButtonItem(customView: self)
    }
}
