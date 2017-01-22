//
//  SearchViewController.swift
//  DishwasherApp
//
//  Created by Matt Harding on 22/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    let remoteProductAPI: RemoteProductAPI = FeatureFactory.remoteProductAPI()
    var searchResult: SearchResult?
    
    // MARK:- UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refresh(withSearchTerm: "dishwasher")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK:- Reload Data
    
    fileprivate func reloadData() {
        collectionView.reloadData()
    }
}

// MARK:- UICollectionView DataSource

extension SearchViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return searchResult?.products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell,
        let searchResult = self.searchResult,
        let product = searchResult.products[safe: indexPath.row]
        else {
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = product.title
        cell.subtitleLabel.text = product.price.now
        
        return cell
    }
}

// MARK:- Product Search API

extension SearchViewController {
    
    fileprivate func refresh(withSearchTerm searchTerm: String) {
        remoteProductAPI.search(for: searchTerm) { [weak self] result in
            
            DispatchQueue.main.async()  {
                switch result {
                case .success(let searchResult):
                    self?.searchResult = searchResult
                    self?.reloadData()
                    
                case .error(let error): break
                    // TODO display a retry screen
                }
            }
        }
    }
}
