//
//  ProductDetailsInteractor.swift
//  GoustoTest
//
//  Created by Oleksiy Chebotarov on 20.01.2018.
//  Copyright (c) 2018 OleksiyCheborarov. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ProductDetailsBusinessLogic {
    func showDescriptions(requests: ProductDetails.ShowDesctiptions.Request)
}

protocol ProductDetailsDataStore {
    var product: Goods! { get set }
}

class ProductDetailsInteractor: ProductDetailsBusinessLogic, ProductDetailsDataStore {
    var presenter: ProductDetailsPresentationLogic?
    var product: Goods!
  
  // MARK: Do something
  
    func showDescriptions(requests: ProductDetails.ShowDesctiptions.Request) {
        var categoriesString: String = ""
        
        if let categories = product.categories {
            for index in 0..<categories.count {
                let categoryTitle = categories[index]
                categoriesString += categoryTitle

                if (index != categories.count - 1) {
                    categoriesString += ", "
                }
            }
        }

        let response = ProductDetails.ShowDesctiptions.Response(product: product, categories: categoriesString)
        presenter?.showDescriptions(response: response)
    }
}
