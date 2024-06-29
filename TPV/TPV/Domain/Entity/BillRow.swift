//
//  BillItem.swift
//  TPV
//
//  Created by Pablo Ceacero on 14/5/24.
//

import Foundation

struct BillRow: Identifiable {
    let item: Item
    var orderedQuantity: Int
    var paidQuantity: Int
    var chargedPaidQuantity: Int

    var pendingQuantity: Int {
        orderedQuantity - chargedPaidQuantity - paidQuantity
    }

    var orderedPrice: Double {
        (Double(orderedQuantity) * item.price).round(to: 2)
    }

    var paidPrice: Double {
        (Double(paidQuantity) * item.price).round(to: 2)
    }

    var chargedPaidPrice: Double {
        (Double(chargedPaidQuantity) * item.price).round(to: 2)
    }

    var pendingPrice: Double {
        (Double(pendingQuantity) * item.price).round(to: 2)
    }

    var id: String {
        item.name
    }
}

extension BillRow {
    func toDTO() -> BillRowDTO {
        return BillRowDTO(orderedQuantity: orderedQuantity,
                          paidQuantity: paidQuantity,
                          item: item.toDTO())
    }
}


struct BillRowDTO: Codable {
    var orderedQuantity: Int
    var paidQuantity: Int
    var item: ItemDTO
}

extension BillRowDTO {
    func toEntity() -> BillRow {
        return BillRow(item: item.toEntity(),
                       orderedQuantity: orderedQuantity,
                       paidQuantity: paidQuantity,
                       chargedPaidQuantity: 0)
    }
}
