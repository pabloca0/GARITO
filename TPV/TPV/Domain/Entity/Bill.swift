//
//  Bill.swift
//  TPV
//
//  Created by Pablo Ceacero on 9/5/24.
//

import UIKit

struct Bill: Identifiable {
    let id: UUID
    let name: String
    let createdDate: Date
    var rows: [BillRow]

    var status: Status {
        if rows.first(where: { $0.orderedQuantity > $0.paidQuantity }) != nil {
            return .pending
        } else if rows.allSatisfy({
            $0.orderedQuantity > 0 &&
            $0.orderedQuantity == $0.paidQuantity
        }) {
            return .closed
        }
        return .open
    }

    var totalPrice: Double {
        var price = 0.0
        rows.forEach({ price += $0.orderedPrice })
        return price.round(to: 2)
    }

    init(name: String, rows: [BillRow]) {
        self.id = UUID()
        self.name = name
        self.createdDate = Date()
        self.rows = rows
    }
}

extension Bill {
    enum Status {
        case open
        case pending
        case closed

        var displayColor: UIColor {
            switch self {
            case .open: UIColor(red: 0, green: 143 / 255, blue: 57 / 255, alpha: 1)
            case .pending: .orange
            case .closed: .red
            }
        }

        var displayName: String {
            switch self {
            case .open: "ABIERTA"
            case .pending: "PENDIENTE"
            case .closed: "CERRADA"
            }
        }
    }
}
