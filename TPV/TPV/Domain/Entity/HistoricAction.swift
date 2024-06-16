//
//  HistoricAction.swift
//  TPV
//
//  Created by Pablo Ceacero on 16/6/24.
//

import Foundation

struct HistoricAction {
    let date: Date
    let action: Action

    enum Action {
        case addItem(Item)
        case deleteItem(Item)
        case charge([Item: Int])

        var description: String {
        
            switch self {
            case .addItem(let item):
                return "Se ha añadido 1 \(item.name)"
            case .deleteItem(let item):
                return "Se ha eliminado 1 \(item.name)"
            case .charge(let chargedItems):

                let result = chargedItems.map { "\t\($0.value) \($0.key.name)" }.joined(separator: "\n")
                return "Se ha cobrado:\n" + result
            }
        }

        var emoji: String {
            switch self {
            case .addItem:
                return "➕"
            case .deleteItem(_):
                return "➖"
            case .charge(_):
                return "💲"
            }
        }
    }
}
