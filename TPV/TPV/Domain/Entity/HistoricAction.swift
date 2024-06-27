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
        case addItem(String)
        case deleteItem(String)
        case charge([String: Int])

        var identifier: String {
            switch self {
            case .addItem:
                return "add"
            case .deleteItem:
                return "delete"
            case .charge:
                return "charge"
            }
        }

        var description: String {
        
            switch self {
            case .addItem(let name):
                return "Se ha añadido 1 \(name)"
            case .deleteItem(let name):
                return "Se ha eliminado 1 \(name)"
            case .charge(let chargedItems):

                let result = chargedItems.map { "\t\($0.value) \($0.key)" }.joined(separator: "\n")
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

struct HistoricActionDTO: Codable {
    let date: String
    let action: String
    let detail: [Detail]

    struct Detail: Codable {
        let itemName: String
        let quantity: Int
    }
}

extension HistoricActionDTO {
    func toEntity() -> HistoricAction? {
        var entityAction: HistoricAction.Action? {
            switch action {
            case "add":
                guard let name = detail.first?.itemName else { return nil }
                return .addItem(name)

            case "delete":
                guard let name = detail.first?.itemName else { return nil }
                return .deleteItem(name)

            case "charge":
                let chargedItems: [String: Int] = detail.reduce([:]) { partialResult, detail in
                    var result = partialResult
                    result[detail.itemName] = detail.quantity
                    return result
                }


                return .charge(chargedItems)
            default:
                return nil
            }
        }

        guard let date = date.toDate(withFormat: .backend),
              let entityAction else { return nil }

        return HistoricAction(date: date,
                              action: entityAction)

    }
}
