//
//  TabBarNavigationViewController.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 05/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import UIKit

class TabBarNavigationController: UITabBarController {

    
    @IBAction func onRefreshButtonPressed(_ sender: Any) {
        if let viewController = self.selectedViewController {
            (viewController as! LoadDataProtocol).loadData()
        }
    }
    
    @IBAction func onAddNewPinButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Segues.addNewPin, sender: nil)
    }
    
    @IBAction func onSignOutButtonPressed(_ sender: Any) {
        activityIndicator("Signin out...")
        AuthenticationService.logout { (result, error) in
            if error != nil {
                self.alert(title: "Error", description: error?.localizedDescription, style: .alert, actions: [], viewController: nil)
                self.closeActivity()
                return;
            }
            self.closeActivity()

            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
