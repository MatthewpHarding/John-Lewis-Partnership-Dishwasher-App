//
//  ProductContainerViewController.swift
//  DishwasherApp
//
//  Created by Matt Harding on 23/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit

private struct Config {
    
    struct segues {
        
        static let masterContent = "MasterContent"
        static let detailContent = "DetailContent"
    }
    
    struct nibName {
        
        static let loadingViewController = "LoadingViewController"
    }
}

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
    
    @IBOutlet var detailContainerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var detailContainerViewWidthConstraint: NSLayoutConstraint!
    
    let remoteProductAPI: RemoteProductAPI = FeatureFactory.remoteProductAPI()
    var productDetail: ProductDetail?
    var productIdentifier: String?
    
    var loadingViewController: LoadingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let productIdentifier = self.productIdentifier {
            displayLoadingView()
            refresh(withProductIdentifier: productIdentifier)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let size = view.bounds.size
        setLayoutType(for: size)
        layoutContainerViews(for: layoutType, withSize: size)
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
        let detailContainerViewWidth = widthPercentage * size.width
        let valueToHideDetailView = -detailContainerViewWidth
        let trailingPosition = layoutType == .split ? 0.0 : valueToHideDetailView
        
        view.layoutIfNeeded()
        detailContainerViewWidthConstraint.constant = detailContainerViewWidth
        detailContainerViewTrailingConstraint.constant = trailingPosition
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
        case Config.segues.masterContent:
            productTableViewController = segue.destination as? ProductTableViewController
            
        case Config.segues.detailContent:
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
        
        let price = PriceInfoCellPresenter(productDetail: productDetail)
        datasource.append(price)
        
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
        
        displayLoadingView()
        remoteProductAPI.getDetails(for: productIdentifier) { [weak self] result in
            
            DispatchQueue.main.async()  { [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                    
                case .success(let productDetail):
                    strongSelf.productDetail = productDetail
                    strongSelf.reload()
                    strongSelf.hideLoadingView()
                    
                case .error: break
                    strongSelf.loadingViewController?.stopRefreshing()
                }
            }
        }
    }
}

// MARK:- Loading

extension ProductContainerViewController: LoadingViewControllerDelegate {
    
    func retry(forLoadingViewController: LoadingViewController) {
        
        if let productIdentifier = self.productIdentifier {
            refresh(withProductIdentifier: productIdentifier)
        }
    }
    
    fileprivate func hideLoadingView() {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
            self?.loadingViewController?.view.alpha = 0.0
        }) { [weak self] _ in
            self?.loadingViewController?.view.removeFromSuperview()
            self?.loadingViewController = nil
        }
    }
    
    fileprivate func displayLoadingView() {
        
        if let loadingViewController = self.loadingViewController {
            loadingViewController.startRefreshing()
            return
        }
        
        let loadingViewController = LoadingViewController(nibName: Config.nibName.loadingViewController, bundle: nil)
        loadingViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadingViewController.view.frame.size = view.bounds.size
        
        add(loadingViewController, toView: self.view)
        
        loadingViewController.delegate = self
        loadingViewController.startRefreshing(whileHidingContent: true)
        self.loadingViewController = loadingViewController
    }
}
