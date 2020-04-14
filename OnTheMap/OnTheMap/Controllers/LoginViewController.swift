//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 03/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Actions
    @IBAction func doLogin(){
        guard let email = emailTextField?.text, let password = passwordTextField?.text, !email.isEmpty && !password.isEmpty else {
            self.alert(title: "Missing credentials", description: "Please fill in your login data", style: .alert, actions: [], viewController: nil)
            return
        }
        let loginData = LoginFormData()
        loginData.username = emailTextField?.text
        loginData.password = passwordTextField?.text
        activityIndicator("Loggin...")
        AuthenticationService.login(loginData: loginData) { (isLogged, error) in
            if error != nil {
                self.closeActivity()
                self.alert(title: "Error", description: error?.localizedDescription, style: .alert, actions: [], viewController: nil)
                return
            }
            if isLogged == false {
                self.closeActivity()
                self.alert(title: "Invalid credentials", description: "Please review the entered information", style: .alert, actions: [], viewController: nil)
                return
            }
            self.closeActivity()
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.loginSuccesful, sender: nil)
            }
        }
        
    }
    
}


