//
//  AddMapViewController.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import Foundation
import MapKit

class AddMapViewController: UIViewController, MKMapViewDelegate, UINavigationControllerDelegate {
    
    static var identifier = "AddMapViewController"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var finishAddLocationButton: UIButton!
    @IBOutlet weak var webTextField: UITextField!
    
    var studentInformation: StudentInformation?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            if let studentLocation = studentInformation {
                let studentLocation = Location(
                    objectId: studentLocation.objectId ?? "",
                    uniqueKey: studentLocation.uniqueKey,
                    firstName: studentLocation.firstName,
                    lastName: studentLocation.lastName,
                    mapString: studentLocation.mapString,
                    mediaURL: webTextField.text ?? "",
                    latitude: studentLocation.latitude,
                    longitude: studentLocation.longitude,
                    createdAt: studentLocation.createdAt ?? "",
                    updatedAt: studentLocation.updatedAt ?? ""
                )
                showLocations(location: studentLocation)
            }
        }
    
    @IBAction func cancelEvent(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
        @IBAction func finishAddLocation(_ sender: UIButton) {
            guard let url = URL(string: self.webTextField.text!), UIApplication.shared.canOpenURL(url) else {
                            self.showAlert(message: "Please include 'http://' in your link.", title: "Invalid URL")
                            return
                        }
            if let studentLocation = studentInformation {
                if UdacityData.Auth.objectId == "" {
                        UdacityData.addStudentLocation(information: studentLocation) { (success, error) in
                            if success {
                                DispatchQueue.main.async {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                                }
                            }
                        }
                } else {
                    let alertVC = UIAlertController(title: "", message: "This student has already posted a location. Would you like to overwrite this location?", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action: UIAlertAction) in
                        UdacityData.updateStudentLocation(information: studentLocation) { (success, error) in
                            if success {
                                DispatchQueue.main.async {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                                }
                            }
                        }
                    }))
                    alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                        DispatchQueue.main.async {
                            alertVC.dismiss(animated: true, completion: nil)
                        }
                    }))
                    self.present(alertVC, animated: true)
                }
            }
            guard studentInformation != nil else {
                return
            }
           let controller = MapViewController()
            if finishAddLocationButton.isSelected {
                showLocations(location: Location(objectId: "", uniqueKey: "", firstName: "", lastName: "", mapString: "", mediaURL: "", latitude: 0.00, longitude: 0.00, createdAt: "", updatedAt: ""))
            } else {
                return
            }
            present(controller, animated: true, completion: nil)
        }
                
         func showLocations(location: Location) {
             self.activityIndicator.startAnimating()
            mapView.removeAnnotations(mapView.annotations)
            if let coordinate = extractCoordinate(location: location) {
                let annotation = MKPointAnnotation()
                annotation.title = location.locationLabel
                annotation.subtitle = location.mediaURL ?? ""
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
                mapView.showAnnotations(mapView.annotations, animated: true)
                self.activityIndicator.isHidden = true
            }
        }
        
         func extractCoordinate(location: Location) -> CLLocationCoordinate2D? {
            if let lat = location.latitude, let lon = location.longitude {
                return CLLocationCoordinate2DMake(lat, lon)
            }
            return nil
        }
    }