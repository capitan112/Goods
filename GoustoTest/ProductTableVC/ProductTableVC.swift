//
//  ProductTableVC.swift
//  GoustoTest
//
//  Created by Капитан on 01.06.17.
//  Copyright © 2017 OleksiyCheborarov. All rights reserved.
//

import UIKit
import SDWebImage

protocol ProductTableDisplayLogic: class {
    func displayLoadingData(viewModel: ProductTable.LoadData.ViewModel)
    func reloadTableView(viewModel: ProductTable.FilterCategory.ViewModel)
}

class ProductTableVC: UITableViewController, UINavigationControllerDelegate, UISearchBarDelegate, ProductTableDisplayLogic {
    var interactor: (ProductTableBusinessLogic & ProductTableDataStore)?
    var router: (NSObjectProtocol & ProductTableRoutingLogic & ProductTableDataPassing)?
    var transitionAnimation: CEReversibleAnimationController!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Object lifecycle
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
        let interactor = ProductTableInteractor()
        let presenter = ProductTablePresenter()
        let router = ProductTableRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        let request = ProductTable.LoadData.Request()
        interactor?.loadData(request: request)
    }

    fileprivate func config() {
        self.title = "Products"
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCellId")
        navigationController?.delegate = self
        searchBar.delegate = self
        transitionAnimation = CECardsAnimationController()
        showIndicator()
    }
    
    func displayLoadingData(viewModel: ProductTable.LoadData.ViewModel) {
        hideIndicator()
    }
    
    // MARK: - Show/hide indicator
    
    func showIndicator() {
        performUIUpdatesOnMain {
            LoadingIndicatorView.show()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    func hideIndicator() {
        performUIUpdatesOnMain {
            LoadingIndicatorView.hide()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
    }
    
    func reloadTableView(viewModel: ProductTable.FilterCategory.ViewModel) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = interactor?.filteredData.count {
            return count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellId", for: indexPath) as! CustomCell
        
        let title = interactor?.filteredData[indexPath.row].title
        cell.titleLabel.text = title

        let description = interactor?.filteredData[indexPath.row].descriptions
        cell.descriptionLabel.text = description
        
        var categoryString:String = ""
        if let itemCategories = interactor?.filteredData[indexPath.row].categories {
            for categoryTitle in itemCategories {
                categoryString += categoryTitle
                categoryString += "\n"
            }
        }
        
        cell.category.text = categoryString
        if let price = interactor?.filteredData[indexPath.row].price {
            cell.priceLabel.text = "£" + price
        } else {
            cell.priceLabel.text = ""
        }
        
        cell.photoImageView.image = UIImage(named: "questionMark")
        cell.photoImageView.layer.cornerRadius = 20
        cell.photoImageView.layer.masksToBounds = true
        if let imageUrl = interactor?.filteredData[indexPath.row].imageUrl {
            cell.photoImageView.sd_setImage(with: URL(string:imageUrl), placeholderImage: UIImage(named: "questionMark"))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = self.interactor?.filteredData[indexPath.row]
        self.interactor?.selectedProduct = selectedProduct
        router?.routeToProductDetailsVC(segue: nil)
    }

    // MARK: - Transition animation
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let toVCIndex = navigationController.viewControllers.index(of: toVC)
        let reverse = (toVCIndex == 1) ? true : false
        transitionAnimation.reverse = reverse
        
        return transitionAnimation
    }
    
    // MARK: - SearchBar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request = ProductTable.FilterCategory.Request(filterText: searchText)
        interactor?.filterCategory(request: request)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
