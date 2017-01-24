//
//  ProductTableViewController.swift
//  DishwasherApp
//
//  Created by Matt Harding on 23/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit

class ProductTableViewController: UITableViewController {
    
    var dataSource: [ProductDetailPresenter] = []
    var galleryViewController: GalleryViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        tableView.register(UINib(nibName: "PriceInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "PriceInfoTableViewCell")
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
        tableView.register(UINib(nibName: "AttributeTableViewCell", bundle: nil), forCellReuseIdentifier: "AttributeTableViewCell")
        tableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
        tableView.register(UINib(nibName: "ProductCodeTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductCodeTableViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PriceInfoTableViewCell", for: indexPath) as? PriceInfoTableViewCell {
                cell.presenter = presenter
                return cell
            }
        case let presenter as  TitleCellPresenter:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as? TitleTableViewCell {
                cell.presenter = presenter
                return cell
            }
        case let presenter as  AttributeCellPresenter:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AttributeTableViewCell", for: indexPath) as? AttributeTableViewCell {
                cell.presenter = presenter
                return cell
            }
        case let presenter as  DescriptionCellPresenter:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as? DescriptionTableViewCell {
                cell.presenter = presenter
                return cell
            }
        case let presenter as  ProductCodeCellPresenter:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCodeTableViewCell", for: indexPath) as? ProductCodeTableViewCell {
                cell.presenter = presenter
                return cell
            }
            
        default: break
        }
        return UITableViewCell()
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let identifier = segue.identifier
            else {
                return
        }
        
        switch identifier {
        case "GalleryContent":
            galleryViewController = segue.destination as? GalleryViewController
        default: break
        }
    }

    func reload(with dataSource: [ProductDetailPresenter], imageURLs: [URL]? = nil) {
        self.dataSource = dataSource
        galleryViewController?.imageURLs = imageURLs
        tableView.reloadData()
    }

}
