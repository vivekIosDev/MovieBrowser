//
//  UiViewController.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar() {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setNavBarColor() {
        navigationController?.navigationBar.barTintColor = UIColor.blue
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        /*
         for view in self.view.subviews {
         if (view is UITextField) {
         let textField = view as! UITextField
         textField.resignFirstResponder()
         }
         }
         */
        view.endEditing(true)
    }
    
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Ok",
                style: UIAlertAction.Style.default,
                handler: {
                    alertAction in
                    self.handleAlertActionOkClicked()
                }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleAlertActionOkClicked() {
        
    }

}
