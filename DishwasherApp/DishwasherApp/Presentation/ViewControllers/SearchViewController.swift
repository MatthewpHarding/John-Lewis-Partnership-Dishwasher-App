//
//  SearchViewController.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit

private struct Config {
    
    struct nibName {
        
        static let loadingViewController = "LoadingViewController"
    }
}

class SearchViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    let searchTerm = "Dishwasher"
    let remoteProductAPI: RemoteProductAPI = FeatureFactory.remoteProductAPI()
    var searchResult: SearchResult?
    var datasource: [ProductPresenter] = []
    
    var loadingViewController: LoadingViewController?
    
    // MARK:- UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = searchTerm
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        refresh(withSearchTerm: searchTerm)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            let identifier = segue.identifier
            else {
                return
        }
        
        switch identifier {
        case "ProductDetail":
            if
                let productContainerViewController = segue.destination as? ProductContainerViewController,
                let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first,
                let selectedProduct = searchResult?.products[safe: selectedIndexPath.row] {
                    productContainerViewController.productIdentifier = selectedProduct.identifier
                    productContainerViewController.title = selectedProduct.title
            }
            
        default: break
        }
    }

    // MARK:- Reload Data
    
    fileprivate func reloadData() {
        
        self.navigationItem.title = String(format: NSLocalizedString("%@ (%li)", comment: ""), searchTerm, searchResult?.results ?? 0)
        collectionView.reloadData()
    }
    
    fileprivate func generateDataSource(withSearchResult searchResult: SearchResult) -> [ProductPresenter] {
        
        return searchResult.products.map({ ProductPresenter(product: $0) })
    }
}

// MARK:- UICollectionView DataSource

extension SearchViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell,
            let presenter = datasource[safe: indexPath.row]
        else {
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = presenter.title
        cell.subtitleLabel.text = presenter.subTitle
        cell.imageUrl = presenter.imageUrl
        
        return cell
    }
    
}

// MARK:- Product Search API

extension SearchViewController {
    
    fileprivate func refresh(withSearchTerm searchTerm: String) {
        
        displayLoadingView()
        remoteProductAPI.search(for: searchTerm) { [weak self] result in
            
            DispatchQueue.main.async()  {  [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let searchResult):
                    strongSelf.searchResult = searchResult
                    strongSelf.datasource = strongSelf.generateDataSource(withSearchResult: searchResult)
                    strongSelf.reloadData()
                    strongSelf.hideLoadingView()
                    
                case .error: break
                    strongSelf.loadingViewController?.stopRefreshing()
                }
            }
        }
    }
}

// MARK:- Loading

extension SearchViewController: LoadingViewControllerDelegate {
    
    func retry(forLoadingViewController: LoadingViewController) {

        refresh(withSearchTerm: searchTerm)
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
