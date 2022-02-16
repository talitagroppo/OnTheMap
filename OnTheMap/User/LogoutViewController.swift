//
//  LogoutViewController.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import Foundation
import UIKit

class LogoutViewController: UIViewController {
    
    @IBOutlet var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var logoutUdacity = LogoutUdacity()
    
    @IBAction func logoutTapped (_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        logoutUdacity.logoutUdacity {_ in 
                   Alert.alertTypeClass.alert(view: self, title: "", message: "")
                   return
               }
               DispatchQueue.main.async {
                   guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
    
                       Alert.alertTypeClass.alert(view: self, title: "Happens a problem", message: "Please try again")
                       return
                   }
                   self.navigationController?.pushViewController(vc, animated: true)
           }
        }
}
class Alert: NSObject {
static let alertTypeClass = Alert()

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
