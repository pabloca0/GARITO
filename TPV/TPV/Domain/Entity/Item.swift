//
//  Item.swift
//  TPV
//
//  Created by Pablo Ceacero on 13/5/24.
//

import UIKit

struct Item: Identifiable {
    let id: UUID = UUID()
    let name: String
    let price: Double
    let image: UIImage?
    let category: ItemFactory.Category
}
