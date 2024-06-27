//
//  Item.swift
//  TPV
//
//  Created by Pablo Ceacero on 13/5/24.
//

import UIKit

struct Item: Hashable {
    let name: String
    let price: Double
    let image: UIImage?
    let category: ItemFactory.Category
}

extension Item {
    func toDTO() -> ItemDTO {
        ItemDTO(name: name,
                price: price,
                category: category.rawValue)
    }
}

struct ItemDTO: Codable {
    let name: String
    let price: Double
    let category: String
}

extension ItemDTO {
    func toEntity() -> Item {
        Item(name: name,
             price: price,
             image: nil,
             category: .init(rawValue: category) ?? .other)
    }
}
