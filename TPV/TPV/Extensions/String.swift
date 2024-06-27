//
//  String.swift
//  TPV
//
//  Created by Pablo Ceacero on 24/6/24.
//

import Foundation

extension String {
    func toDate(withFormat format: Date.DateType) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.date(from: self)
    }
}
