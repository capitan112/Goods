//
//  ProductDetailsVC.swift
//  GoustoTest
//
//  Created by Капитан on 02.06.17.
//  Copyright © 2017 OleksiyCheborarov. All rights reserved.
//

import UIKit
import SDWebImage

protocol ProductDetailsDisplayLogic: class {
    func showDescriptions(viewModel:ProductDetails.ShowDesctiptions.ViewModel )
}

class ProductDetailsVC: UIViewController, ProductDetailsDisplayLogic {

    var interactor: (ProductDetailsBusinessLogic & ProductDetailsDataStore)?
    var router: (NSObject & ProductDetailsRoutingLogic & ProductDetailsDataPassing)?
    
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDescriptionLabel: VerticalAlignLabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = ProductDetailsInteractor()
        let presenter = ProductDetailsPresenter()
        let router = ProductDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configData()
    }
    
    func configData() {
        self.title = "Description"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        let request = ProductDetails.ShowDesctiptions.Request()
        interactor?.showDescriptions(requests: request)
        productDescriptionLabel.sizeToFit()
    }
    
    func showDescriptions(viewModel: ProductDetails.ShowDesctiptions.ViewModel) {
        priceLabel.text = "£" +  viewModel.product.price!
        productDescriptionLabel.text = viewModel.product.descriptions
        if let imageUrl = viewModel.product.imageUrl {
            productImageView.sd_setImage(with: URL(string:imageUrl), placeholderImage: UIImage(named: "questionMark"))
        }
        categoriesLabel.text = viewModel.categories
    }
    
    // MARK: - Button handling
    @objc func addTapped() {
//  implement interactor.ButtonTapped()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
