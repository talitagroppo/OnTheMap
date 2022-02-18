//
//  AddMapViewController.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import Foundation
import MapKit

class AddMapViewController: UIViewController, MKMapViewDelegate {
    
    static var identifier = "AddMapViewController"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webTextField: UITextField!
    
    private let tapButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        return button
    }()
    
    @objc func tappedButton() {
        finished()
    }
    
    var studentInformation: StudentInformation?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let studentLocation = studentInformation {
                   let studentLocation = StudentInformation(
                    createdAt: studentLocation.createdAt ?? "",
                    firstName: studentLocation.firstName ,
                    lastName: studentLocation.lastName,
                    latitude: studentLocation.latitude,
                    longitude: studentLocation.longitude,
                    mapString:  studentLocation.mapString,
                    mediaURL: studentLocation.mediaURL,
                    objectId: studentLocation.objectId,
                    uniqueKey: studentLocation.uniqueKey ?? "",
                    updatedAt: studentLocation.updatedAt ?? ""
                   )
                   showLocations(location: studentLocation)
               }
        view.addSubview(tapButton)
        tapButton.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        tapButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        mapView.delegate = self
    }
    
    @IBAction func cancelEvent(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    func finished() {
        guard let url = URL(string: self.webTextField.text!) else {
            self.showAlert(message: "Please include 'www' in your link.", title: "Invalid URL")
            return
        }
        if let studentLocation = studentInformation {
            if UdacityData.Auth.objectId == "" {
                UdacityData.addStudentLocation(information: studentLocation) { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            UIApplication.shared.canOpenURL(url)
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                        }
                    }
            }
            }
        }
        guard studentInformation != nil else {
            return
        }
        let controller = MapViewController()
        present(controller, animated: true, completion: nil)
    }
    
    func showLocations(location: StudentInformation) {
        self.activityIndicator.startAnimating()
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = extractCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.uniqueKey
            annotation.subtitle = location.mediaURL
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
            self.activityIndicator.isHidden = true
        }
    }
    
    func extractCoordinate(location: StudentInformation) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
           if webTextField.isFirstResponder {
               view.frame.origin.y = getKeyboardHeight(notification) * (0)
           }
}
}

