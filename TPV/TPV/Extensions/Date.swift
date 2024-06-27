//
//  Date.swift
//  TPV
//
//  Created by Pablo Ceacero on 16/6/24.
//

import Foundation

extension Date {
    func toString(withFormat format: DateType) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }

    enum DateType: String {
        case backend = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case historicAction = "MM-dd-yyyy HH:mm:ss"
    }
}
