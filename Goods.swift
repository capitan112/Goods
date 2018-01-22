//
//  Goods.swift
//  GoustoTest
//
//  Created by Капитан on 02.06.17.
//  Copyright © 2017 OleksiyCheborarov. All rights reserved.
//

import Foundation

class Goods {
    var title: String?
    var price: String?
    var descriptions: String?
    var imageUrl: String?
    var categories: Array<String>?

    init(product: Product, categories: Array<String>?) {
        self.title = product.title
        self.price = product.price
        self.descriptions = product.descriptions
        self.imageUrl = product.imageUrl
        self.categories = categories
    }
}
