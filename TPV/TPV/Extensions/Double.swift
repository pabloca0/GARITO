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

    func toCurrency() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "es_ES")
        numberFormatter.numberStyle = .currency
        if self == floor(self) {
            // Sin decimales
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
        } else {
            // Con 2 decimales
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
        }
        guard let result = numberFormatter.string(from: NSNumber(value: self)) else { return "" }
        return result
    }
}
