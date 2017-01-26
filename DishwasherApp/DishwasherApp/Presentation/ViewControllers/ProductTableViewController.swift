//
//  ProductTableViewController.swift
//  DishwasherApp
//
//  Created by Matt Harding on 23/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit

private struct Config {
    
    struct nibName {
        
        static let priceInfo = "PriceInfoTableViewCell"
        static let title = "TitleTableViewCell"
        static let attribute = "AttributeTableViewCell"
        static let description = "DescriptionTableViewCell"
        static let productCode = "ProductCodeTableViewCell"
    }
    
    struct cellIdentifiers {
        
        static let priceInfo = "PriceInfoTableViewCell"
        static let title = "TitleTableViewCell"
        static let attribute = "AttributeTableViewCell"
        static let description = "DescriptionTableViewCell"
        static let productCode = "ProductCodeTableViewCell"
    }
    
    struct segues {
    
        static let galleryContent = "GalleryContent"
    }
}

class ProductTableViewController: UITableViewController {
    
    var dataSource: [ProductDetailPresenter] = []
    var galleryViewController: GalleryViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
    
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        tableView.register(UINib(nibName: Config.nibName.priceInfo, bundle: nil), forCellReuseIdentifier: Config.cellIdentifiers.priceInfo)
        tableView.register(UINib(nibName: Config.nibName.title, bundle: nil), forCellReuseIdentifier: Config.cellIdentifiers.title)
        tableView.register(UINib(nibName: Config.nibName.attribute, bundle: nil), forCellReuseIdentifier: Config.cellIdentifiers.attribute)
        tableView.register(UINib(nibName: Config.nibName.description, bundle: nil), forCellReuseIdentifier: Config.cellIdentifiers.description)
        tableView.register(UINib(nibName: Config.nibName.productCode, bundle: nil), forCellReuseIdentifier: Config.cellIdentifiers.productCode)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let presenter = dataSource[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        switch presenter {
        case let presenter as  PriceInfoCellPresenter:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Config.cellIdentifiers.priceInfo, for: indexPath) as? PriceInfoTableViewCell {
                cell.presenter = presenter
                return cell
            }
        case let presenter as  TitleCellPresenter:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Config.cellIdentifiers.title, for: indexPath) as? TitleTableViewCell {
                cell.presenter = presenter
                return cell
            }
        case let presenter as  AttributeCellPresenter:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Config.cellIdentifiers.attribute, for: indexPath) as? AttributeTableViewCell {
                cell.presenter = presenter
                return cell
            }
        case let presenter as  DescriptionCellPresenter:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Config.cellIdentifiers.description, for: indexPath) as? DescriptionTableViewCell {
                cell.presenter = presenter
                return cell
            }
        case let presenter as  ProductCodeCellPresenter:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Config.cellIdentifiers.productCode, for: indexPath) as? ProductCodeTableViewCell {
                cell.presenter = presenter
                return cell
            }
            
        default: break
        }
        return UITableViewCell()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            let identifier = segue.identifier
            else {
                return
        }
        
        switch identifier {
        case Config.segues.galleryContent:
            galleryViewController = segue.destination as? GalleryViewController
        default: break
        }
    }

    func reload(with dataSource: [ProductDetailPresenter], imageURLs: [URL]? = nil) {
        
        self.dataSource = dataSource
        galleryViewController?.imageURLs = imageURLs
        tableView.reloadData()
    }
    
    func reloadInformation(with dataSource: [ProductDetailPresenter]) {
        
        self.dataSource = dataSource
        tableView.reloadData()
    }

}
