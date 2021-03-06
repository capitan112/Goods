//
//  ProductTablePresenter.swift
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

protocol ProductTablePresentationLogic {
    func loadingComplete(response: ProductTable.LoadData.Response)
    func filterCategory(response: ProductTable.FilterCategory.Response)
}

class ProductTablePresenter: ProductTablePresentationLogic {
  weak var viewController: ProductTableDisplayLogic?
  
  // MARK: Do something

    func loadingComplete(response: ProductTable.LoadData.Response) {
        let viewModel = ProductTable.LoadData.ViewModel()
        viewController?.displayLoadingData(viewModel: viewModel)
    }
    
    func filterCategory(response: ProductTable.FilterCategory.Response) {
        let viewModel = ProductTable.FilterCategory.ViewModel()
        viewController?.reloadTableView(viewModel: viewModel)
    }
}
