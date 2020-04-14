//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Marius Chelariu on 01/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RefreshDataProtocol {
        
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var tableViewData: [Meme]!
    
    // MARK: Lifecycle Hooks
    override func viewWillAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        tableViewData = MemeService.instance.getItems()
        subscribeToRefresh()
        RefreshData()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
            unsubscribeFromRefresh()
    }
        
    func subscribeToRefresh(){
        NotificationCenter.default.addObserver(self, selector: #selector(RefreshData), name:NSNotification.Name(rawValue: "updateParent"), object: nil)
    }
        
    func unsubscribeFromRefresh(){
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "updateParent"), object: nil)
    }
    
    @objc func RefreshData() {
        tableViewData = MemeService.instance.getItems()
        tableView.reloadData()
    }
    
    // MARK: TableView Inherited methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.memeTableViewCellIdentifier, for: indexPath) as! MemeTableViewCell
        cell.setupCell(tableViewData[indexPath.row])
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let img = tableViewData[indexPath.row].memedImage;
        performSegue(withIdentifier: Segues.memeDisplayFromTable, sender:img)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == Segues.memeDisplayFromTable {
                let viewController = segue.destination as! MemeDisplayViewController
                viewController.image = sender as? UIImage
            }
        }
    
    
    
}
