//
//  AddListViewController.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import Foundation
import MapKit

class AddListViewController: UIViewController {
    
    static var identifier = "AddListViewController"
    
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    
    var objectId: String?
    
    var studentInformation: StudentInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func cancelEvent(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        UdacityData.logout {
            DispatchQueue.main.async {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else { return }
            self.navigationController?.pushViewController(vc, animated: false)
        }
        }
    }
    @IBAction func findLocation(sender: UIButton) {
        guard let newLocation = locationTextField.text
        else { return }
        if newLocation.isEmpty {
            self.showAlert(message: "Please select the location.", title: "Unknow.")
            return
        } else {
            geocodePosition(newLocation: newLocation)
        }
    }
    
    func geocodePosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription, title: "Location Not Found")
                print("Location not found.")
            } else {
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.loadNewLocation(location.coordinate)
                } else {
                    self.showAlert(message: "Please try again later.", title: "Error")
                }
            }
        }
    }
    
    func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AddMapViewController") as! AddMapViewController
        controller.studentInformation = buildStudentInfo(coordinate)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
        
        var studentInfo = [
            "uniqueKey": UdacityData.Auth.key,
            "firstName": firstNameTextField.text!,
            "lastName": lastNameTextField.text!,
            "mapString": locationTextField.text!,
            "mediaURL": UdacityData.Auth.mediaURL,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
        ] as [String: AnyObject]
        
        if let objectId = objectId {
            studentInfo["objectId"] = objectId as AnyObject
            print(objectId)
        }
        
        return StudentInformation(studentInfo)
        
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
           if firstNameTextField.isFirstResponder {
               view.frame.origin.y = getKeyboardHeight(notification) * (0)
           }
           if lastNameTextField.isFirstResponder {
               view.frame.origin.y = getKeyboardHeight(notification) * (-0.2)
           }
           if locationTextField.isFirstResponder {
               view.frame.origin.y = getKeyboardHeight(notification) * (-0.5)
           }
    }
}
