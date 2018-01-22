//
//  ProductMapper.swift
//  GoustoTest
//
//  Created by Oleksiy Chebotarov on 20.01.2018.
//  Copyright © 2018 OleksiyCheborarov. All rights reserved.
//

import Foundation
import MagicalRecord

protocol Mapper {
    func productMapper(dictionary: [[String : Any]])
}

class ProductMapper: Mapper {
    func productMapper(dictionary: [[String : Any]]) {
        Product.mr_truncateAll()
        Category.mr_truncateAll()
        
        for item in dictionary {
            var product: Product!
            
            if (product == nil) {
                product = Product.mr_createEntity()
            }
            
            product.title = item["title"] as! String?
            product.price = item["list_price"] as! String?
            product.descriptions = item["description"] as! String?
            
            guard let images = item["images"] as? [String:[String: Any]] else {
                product.mr_deleteEntity()
                continue
            }
            
            product.imageUrl = images["750"]!["url"] as! String?
            let categories = item["categories"] as? [[String: Any]]
            for category in categories! {
                if let unwrapCategory = category["title"] as? String {
                    let categoryCoreData = Category.mr_createEntity()!
                    categoryCoreData.title = unwrapCategory
                    categoryCoreData.products = product
                    categoryCoreData.managedObjectContext?.mr_saveToPersistentStoreAndWait()
                    product.categories?.adding(categoryCoreData)
                }
            }
            
            product.managedObjectContext?.mr_saveToPersistentStoreAndWait()
        }
    }
}
