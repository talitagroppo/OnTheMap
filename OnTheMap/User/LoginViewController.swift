//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    static var identifier = "LoginViewController"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ConnectNetwork.shared.isConnected {
            return
        } else {
            ConnectNetwork.shared.stopMonitoring()
            showAlert(message: "", title: "The Internet connection is offline, please try again later")
            return
        }
            
    }
    
    var loginUdacity = LoginUdacity()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
        subscribeToKeyboardNotifications()
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func loginTapped (_ sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        guard let email = email,
              email != "",
              let password = password,
              password != ""
        else {
            AlertType.alertTypeClass.alert(view: self, title: "Your need informe the data", message: "You can't be login without the data")
            
            return
        }
        loginUdacity.execute(email: email, password: password) { result in
            if !(result?.account.registered ?? false) {
                AlertType.alertTypeClass.alert(view: self, title: "", message: "The credentials were incorrect, please check your email or/and your password.")
                return
            }
            DispatchQueue.main.async {
                let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
                appDelegate?.uniqueKey = result?.account.key
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") else {
                    AlertType.alertTypeClass.alert(view: self, title: "Happens a problem", message: "Please check again your information")
                    return
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if emailTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * (-0.4)
        }
        if passwordTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * (-0.5)
        }
    }
}
class AlertType: NSObject {
    static let alertTypeClass = AlertType()
    
    func alert(view: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(defaultAction)
        DispatchQueue.main.async(execute: {
            view.present(alert, animated: true)
        })
    }
}
