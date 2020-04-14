//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 05/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import UIKit

class StudentsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LoadDataProtocol {
    
    // MARK: - Properties
    var data:[Student] = [Student]()
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - LifeCycle hooks
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }
    
    // MARK: - 
    
    func loadData() {
        activityIndicator("Loading pins...")
        StudentService.get(order: true) { (students, error) in
            if error != nil {
                self.closeActivity()
                self.alert(title: "Network error", description: error?.localizedDescription, style: .alert, actions: [], viewController: nil)
                return
            }
            self.data = students
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.closeActivity()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCellIdentifier", for: indexPath) as! StudentTableViewCell
        cell.setupView(student: data[indexPath.row])
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openUrl(urlString: data[indexPath.row].mediaURL)
    }
    
    
    
}
