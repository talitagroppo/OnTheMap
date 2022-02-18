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
   
    var objectId: String?
    
    var studentInformation: StudentInformation?
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(studentInformation)
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
        self.activityIndicator.startAnimating()
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
                    self.activityIndicator.stopAnimating()
                } else {
                    self.showAlert(message: "Please try again later.", title: "Error")
                }
            }
        }
    }
    
    func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AddMapViewController") as! AddMapViewController
//        controller.studentInformation = buildStudentInfo(coordinate)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
           if locationTextField.isFirstResponder {
               view.frame.origin.y = getKeyboardHeight(notification) * (-0.5)
           }
    }
}
