//
//  Date.swift
//  TPV
//
//  Created by Pablo Ceacero on 16/6/24.
//

import Foundation

extension Date {
    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
