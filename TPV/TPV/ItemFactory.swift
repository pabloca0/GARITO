//
//  ItemFactory.swift
//  TPV
//
//  Created by Pablo Ceacero on 15/5/24.
//

import Foundation

class ItemFactory {
    static let items: [Item] = [
        Item(name: "TURIA",
             price: 2.0,
             image: nil, category: .beers),
        Item(name: "DAMM LEMON",
             price: 2.0,
             image: nil, category: .beers),
        Item(name: "FREE DAMM",
             price: 2.0,
             image: nil, category: .beers),
        Item(name: "ESTRELLA DAMM",
             price: 1.8,
             image: nil, category: .beers),
        Item(name: "MAHOU",
             price: 1.8,
             image: nil, category: .beers),
        Item(name: "DESPERADOS",
             price: 2.5,
             image: nil, category: .beers),
        Item(name: "ALHAMBRA VERDE",
             price: 2.5,
             image: nil, category: .beers),
        Item(name: "LADRÓN DE MANZANAS",
             price: 2.5,
             image: nil, category: .beers),
        Item(name: "1906 MILNUEVE",
             price: 2.5,
             image: nil, category: .beers),
        Item(name: "ESTRELLA GALICIA",
             price: 2.2,
             image: nil, category: .beers),
        Item(name: "VOLDAMM",
             price: 2.2,
             image: nil, category: .beers),
        Item(name: "CUBATA BARATO",
             price: 6.0,
             image: nil, category: .other),
        Item(name: "CUBATA CARO",
             price: 7.0,
             image: nil, category: .other),
        Item(name: "CUBATA PREMIUM",
             price: 8.0,
             image: nil, category: .other),
        Item(name: "TINTO DE VERANO",
             price: 4.0,
             image: nil, category: .other),
        Item(name: "VAQUERITO BARATO",
             price: 3,
             image: nil, category: .other),
        Item(name: "VAQUERITO CARO",
             price: 5,
             image: nil, category: .other),
        Item(name: "CHUPITO BARATO",
             price: 1.5,
             image: nil, category: .other),
        Item(name: "CHUPITO CARO",
             price: 2.0,
             image: nil, category: .other),
        Item(name: "CHUPITO PREMIUM",
             price: 3.0,
             image: nil, category: .other),
        Item(name: "AGUA",
             price: 1.5,
             image: nil, category: .other),
        Item(name: "AGUA CON GAS",
             price: 2.0,
             image: nil, category: .other),
        Item(name: "REDBULL",
             price: 2.0,
             image: nil, category: .other),
        Item(name: "VERMOUTH",
             price: 3.0,
             image: nil, category: .other),
        Item(name: "ZUMO",
             price: 1.5,
             image: nil, category: .other),
        Item(name: "COPA DE VINO",
             price: 3.0,
             image: nil, category: .other),
        Item(name: "BOTELLA FUENTESECA",
             price: 12.0,
             image: nil, category: .other),
        Item(name: "BOTELLA BOYANTE",
             price: 12.0,
             image: nil, category: .other),
        Item(name: "BOTELLA NOVIO PERFECTO",
             price: 14.0,
             image: nil, category: .other)
    ]

    static func getCategories(from items: [Item]) -> [Category] {
        var categories: [Category] = []
        items.forEach { item in
            if !categories.contains(item.category) {
                categories.append(item.category)
            }
        }
        return categories
    }

    enum Category: String, CaseIterable {
        case beers = "beers"
        case other = "other"
    }
}
