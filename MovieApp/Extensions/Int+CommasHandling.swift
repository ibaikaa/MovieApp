//
//  Int+CommasHandling.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import Foundation

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(
            from: NSNumber(value: self)
        ) ?? "\(self)"
    }
}

