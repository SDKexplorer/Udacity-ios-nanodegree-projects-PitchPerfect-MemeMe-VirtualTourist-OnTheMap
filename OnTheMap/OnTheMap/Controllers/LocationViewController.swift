//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 06/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func onFindOnTheMapButtonPress(_ sender: Any) {
        guard let location = locationTextField.text, !location.isEmpty else {
            alert(title: "Missing location", description: "Please add an location in the field ", style: .alert, actions: [], viewController: nil)
            return
        }
        performSegue(withIdentifier: Segues.findOnMap, sender: nil)
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardNotification()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.findOnMap {
            let viewController = segue.destination as! PinSubmissionViewController
            viewController.address = locationTextField.text
        }
    }
}
