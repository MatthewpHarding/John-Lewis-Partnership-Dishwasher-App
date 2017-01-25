//
//  ProductContainerViewController.swift
//  DishwasherApp
//
//  Created by Matt Harding on 23/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit

class ProductContainerViewController: UIViewController {
    
    enum LayoutType {
        case full
        case split
    }
    
    var layoutType = LayoutType.full
    
    @IBOutlet var mainContainerView: UIView!
    var productTableViewController: ProductTableViewController?
    
    @IBOutlet var detailContainerView: UIView!
    var productDetailTableViewController: ProductTableViewController?
    @IBOutlet var detailContainerViewWidthConstraint: NSLayoutConstraint!
    
    let remoteProductAPI: RemoteProductAPI = FeatureFactory.remoteProductAPI()
    var productDetail: ProductDetail?
    var productIdentifier: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let productIdentifier = self.productIdentifier {
            refresh(withProductIdentifier: productIdentifier)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let size = view.bounds.size
        setLayoutType(for: size)
        layoutContainerViews(for: layoutType, withSize: size)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        setLayoutType(for: size)
        layoutContainerViews(for: layoutType, withSize: size)
        reloadInformation()
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.view.layoutIfNeeded()
        }, completion: nil)
        
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func setLayoutType(for size: CGSize) {
        let shouldDisplayMoreDetailsContainer = size.width > size.height ? true : false
        layoutType = shouldDisplayMoreDetailsContainer ? .split : .full
    }
    
    private func layoutContainerViews(for layoutType: LayoutType, withSize size: CGSize) {
        
        let widthPercentage: CGFloat = 0.3
        let detailContainerViewWidth = layoutType == .split ? (widthPercentage * size.width) : 0.0
        
        view.layoutIfNeeded()
        detailContainerViewWidthConstraint.constant = detailContainerViewWidth
        detailContainerView.setNeedsLayout()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let identifier = segue.identifier
            else {
            return
        }
        
        switch identifier {
        case "MasterContent":
            productTableViewController = segue.destination as? ProductTableViewController
            
        case "DetailContent":
            productDetailTableViewController = segue.destination as? ProductTableViewController
        default: break
        }
    }
    
    // MARK:- Reload Data
    
    fileprivate func reload() {
        
        guard let productDetail = self.productDetail else {
            return
        }
        
        switch layoutType {
        case .full:
            let dataSource = generateFullDataSource(withProductDetail: productDetail)
            productTableViewController?.reload(with: dataSource, imageURLs: productDetail.imageURLs)
            
        case .split:
            let compactDataSource = generateCompactDataSource(withProductDetail: productDetail)
            let companionDataSource = generateCompactCompanionDataSource(withProductDetail: productDetail)
            
            productTableViewController?.reload(with: compactDataSource, imageURLs: productDetail.imageURLs)
            productDetailTableViewController?.reload(with: companionDataSource)
            
        }
    }
    
    fileprivate func reloadInformation() {
        
        guard let productDetail = self.productDetail else {
            return
        }
        
        switch layoutType {
        case .full:
            let dataSource = generateFullDataSource(withProductDetail: productDetail)
            productTableViewController?.reloadInformation(with: dataSource)
            
        case .split:
            let compactDataSource = generateCompactDataSource(withProductDetail: productDetail)
            let companionDataSource = generateCompactCompanionDataSource(withProductDetail: productDetail)
            
            productTableViewController?.reloadInformation(with: compactDataSource)
            productDetailTableViewController?.reloadInformation(with: companionDataSource)
        }
    }
}

// MARK:- Datasource

extension ProductContainerViewController {
    
    fileprivate func generateCompactCompanionDataSource(withProductDetail productDetail: ProductDetail) -> [ProductDetailPresenter] {
        
        var datasource: [ProductDetailPresenter] = []
        
        let price = PriceInfoCellPresenter(productDetail: productDetail)
        datasource.append(price)
        
        return datasource
    }
    
    fileprivate func generateCompactDataSource(withProductDetail productDetail: ProductDetail) -> [ProductDetailPresenter] {
        
        var datasource: [ProductDetailPresenter] = []
        
        let price = PriceInfoCellPresenter(productDetail: productDetail)
        datasource.append(price)
        
        let title = TitleCellPresenter(title: NSLocalizedString("Product Information", comment: ""))
        datasource.append(title)
        
        let code = ProductCodeCellPresenter(productDetail: productDetail)
        datasource.append(code)
        
        let description = DescriptionCellPresenter(productDetail: productDetail)
        datasource.append(description)
        
        if let specificationDataSource = generateProductSpecificationDataSource(withProductDetail: productDetail) {
            datasource.append(contentsOf: specificationDataSource)
        }

        return datasource
    }
    
    fileprivate func generateProductSpecificationDataSource(withProductDetail productDetail: ProductDetail) -> [ProductDetailPresenter]? {
        
        guard
            let informationFeature = productDetail.features.first,
            informationFeature.attributes.count > 0
            else {
                return nil
        }
        
        var datasource: [ProductDetailPresenter] = []
        let specificationTitle = TitleCellPresenter(title: NSLocalizedString("Product Specification", comment: ""))
        datasource.append(specificationTitle)
        
        for productAttribute in informationFeature.attributes {
            let attribute = AttributeCellPresenter(productAttribute: productAttribute)
            datasource.append(attribute)
        }
        return datasource
    }
    
    fileprivate func generateFullDataSource(withProductDetail productDetail: ProductDetail) -> [ProductDetailPresenter] {
        
        var datasource: [ProductDetailPresenter] = []
        
        let title = TitleCellPresenter(title: NSLocalizedString("Product Information", comment: ""))
        datasource.append(title)
        
        let description = DescriptionCellPresenter(productDetail: productDetail)
        datasource.append(description)
        
        let code = ProductCodeCellPresenter(productDetail: productDetail)
        datasource.append(code)
        
        if let informationFeature = productDetail.features.first {
            let numberOfAttributes = informationFeature.attributes.count
            if numberOfAttributes > 0 {
                
                let specificationTitle = TitleCellPresenter(title: NSLocalizedString("Product Specification", comment: ""))
                datasource.append(specificationTitle)
                
                for productAttribute in informationFeature.attributes {
                    let attribute = AttributeCellPresenter(productAttribute: productAttribute)
                    datasource.append(attribute)
                }
            }
        }
        
        return datasource
    }
}

// MARK:- Product Detail API

extension ProductContainerViewController {
    
    fileprivate func refresh(withProductIdentifier productIdentifier: String) {
        remoteProductAPI.getDetails(for: productIdentifier) { [weak self] result in
            
            DispatchQueue.main.async()  {
                switch result {
                case .success(let productDetail):
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.productDetail = productDetail
                    strongSelf.reload()
                    
                case .error: break
                    // TODO display a retry screen
                }
            }
        }
    }
}
