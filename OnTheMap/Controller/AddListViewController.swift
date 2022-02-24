//
//  AddListViewController.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import Foundation
import MapKit

enum GeocodePositionError: Error {
    case unknown
}

typealias GeocodePositionHandler = (Result<CLLocation, Error>) -> Void
typealias LoadNewLocationHandler = (Result<StudentInformation, Error>) -> Void

class AddListViewController: UIViewController {
    
    static var identifier = "AddListViewController"
    
    @IBOutlet var locationTextField: UITextField!
    
    var firstNameTextField: UITextField = {
        var textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "First Name"
        textfield.isHidden = true
        return textfield
    }()
    
    var secondNameTextField: UITextField = {
        var textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Second Name"
        textfield.isHidden = true
        return textfield
    }()
    
    var objectId: String?
    
    var studentInformation: StudentInformation?
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if studentInformation == nil {
            view.addSubview(firstNameTextField)
            view.addSubview(secondNameTextField)
            firstNameTextField.isHidden = false
            secondNameTextField.isHidden = false
            firstNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
            firstNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
            secondNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
            secondNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        }
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
        loadNewLocation { result in
            switch result {
            case .failure(let error):
                self.showAlert(message: error.localizedDescription, title: "Error")
            case .success(let studentInformation):
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddMapViewController") as! AddMapViewController
                controller.studentInformation = studentInformation
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func geocodePosition(newLocation: String, completion: @escaping GeocodePositionHandler) {
        self.activityIndicator.startAnimating()
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription, title: "Location Not Found")
                completion(.failure(error))
            } else {
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    completion(.success(location))
                } else {
                    completion(.failure(GeocodePositionError.unknown))
                }
            }
        }
    }
    
    func loadNewLocation(completion: @escaping LoadNewLocationHandler) {
        guard let locationName = locationTextField.text  else {
            self.showAlert(message: "Please try again later.", title: "Error")
            completion(.failure(GeocodePositionError.unknown))
            return
        }
        geocodePosition(newLocation: locationName) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showAlert(message: "\(error.localizedDescription)", title: "Error")
                completion(.failure(error))
            case .success(let location):
                if var studentLocation = self?.studentInformation {
                    studentLocation.latitude = location.coordinate.latitude
                    studentLocation.longitude = location.coordinate.longitude
                    completion(.success(studentLocation))
                    return
                } else {
                    DispatchQueue.main.async {
                        let uniqueKey = (UIApplication.shared.delegate as? AppDelegate)?.uniqueKey
                        let studentInformation = StudentInformation(
                            createdAt: Date.now.ISO8601Format(),
                            firstName: self?.firstNameTextField.text ?? "Talita",
                            lastName: self?.secondNameTextField.text ?? "Groppo",
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude,
                            mapString: nil,
                            mediaURL: nil,
                            objectId: nil,
                            uniqueKey: uniqueKey,
                            updatedAt: Date.now.ISO8601Format()
                        )
                        completion(.success(studentInformation))
                    }
                }
            }
        }
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
