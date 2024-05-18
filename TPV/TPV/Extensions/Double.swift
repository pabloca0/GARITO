//
//  Double.swift
//  TPV
//
//  Created by Pablo Ceacero on 17/5/24.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
