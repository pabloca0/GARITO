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
    var historicActions = [HistoricAction]()

    var status: Status {
        if rows.first(where: { $0.pendingQuantity > 0 }) != nil {
            return .pending
        } else if rows.first(where: { $0.paidQuantity > 0 }) != nil {
            return .paid
        }
        return .open
    }


    
    var orderedPrice: Double {
        rows.reduce(0, { $0 + $1.orderedPrice }).round(to: 2)
    }

    var pendingPrice: Double {
        rows.reduce(0, { $0 + $1.pendingPrice }).round(to: 2)
    }

    var paidPrice: Double {
        rows.reduce(0, { $0 + $1.paidPrice }).round(to: 2)
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
        case paid

        var displayColor: UIColor {
            switch self {
            case .open: UIColor(red: 17 / 255, green: 76 / 255, blue: 155 / 255, alpha: 1)
            case .pending: .orange
            case .paid: UIColor(red: 0, green: 143 / 255, blue: 57 / 255, alpha: 1)
            }
        }

        var displayName: String {
            switch self {
            case .open: "ABIERTA"
            case .pending: "PENDIENTE"
            case .paid: "PAGADO"
            }
        }
    }
}
