//
//  TextField.swift
//  OnTheMap
//
//  Created by Talita Groppo on 15/02/2022.
//

//import Foundation
//import UIKit
//
//extension AddListViewController {
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    @objc func keyboardWillShow(_ notification: Notification) {
//        if firstNameTextField.isFirstResponder {
//            view.frame.origin.y = getKeyboardHeight(notification) * (0)
//        }
//        if lastNameTextField.isFirstResponder {
//            view.frame.origin.y = getKeyboardHeight(notification) * (-0.2)
//        }
//        if locationTextField.isFirstResponder {
//            view.frame.origin.y = getKeyboardHeight(notification) * (-0.5)
//        }
//    }
//    @objc func keyboardWillHide(_ notification: Notification) {
//        view.frame.origin.y = 0
//    }
//    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
//        let userInfo = notification.userInfo
//        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
//        return keyboardSize.cgRectValue.height
//    }
//     func subscribeToKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
//    }
//    func unsubscribeToKeyboardNotifications() {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
//    }
//}
