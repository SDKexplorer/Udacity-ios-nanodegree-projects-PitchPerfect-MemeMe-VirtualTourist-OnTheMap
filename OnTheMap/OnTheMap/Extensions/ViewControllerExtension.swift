//
//  ViewControllerExtension.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 05/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func alert(title: String, description: String?, style: UIAlertController.Style, actions: [UIAlertAction], viewController: UIViewController?){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: description, preferredStyle: style)
            if actions.count == 0 {
                let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                alert.addAction(closeAction)
            } else {
                for action in actions {
                    alert.addAction(action)
                }
            }

            self.present(alert, animated: true)
        }
    }
    
    func activityIndicator(_ text:String? = "Please wait...") {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func closeActivity() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    func openUrl(urlString: String) {
        let url = URL(string: urlString)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            self.alert(title: "Invalid url", description: "Cannot open \(urlString)", style: .alert, actions: [], viewController: nil)
        }
    }
    
    // MARK: - Keyboard
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow (_ notification: Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide (_ notification: Notification) {
        view.frame.origin.y = 0
    }
}
