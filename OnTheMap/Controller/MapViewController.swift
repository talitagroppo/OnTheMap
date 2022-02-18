//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var addNewLocation: UIBarButtonItem!
    
    var annotations = [MKPointAnnotation]()
    
    var studentInformation: StudentInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        newTest()
    }
    
    func newTest() {
        DispatchQueue.main.async {
            guard let uniqueKey = (UIApplication.shared.delegate as? AppDelegate)?.uniqueKey else { fatalError() }
            DispatchQueue.global(qos: .utility).async {
                let url = UdacityData.Endpoints.getLoggedInUserProfile(uniqueKey).url
                let getProfile = GetLoggedInUserProfile(url: url)
                getProfile.execute { result in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let studentLocation):
                        DispatchQueue.main.async {
                            self.studentInformation = studentLocation
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentsPins()
        navigationController?.navigationBar.isHidden = false
    }
    @IBAction func addNewLocation(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: AddListViewController.identifier) as! AddListViewController
        vc.studentInformation = studentInformation
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func refreshMap(_ sender: UIBarButtonItem) {
        self.activityIndicator.startAnimating()
        mapView.reloadInputViews()
        self.activityIndicator.isHidden = true
    }
    
    func getStudentsPins() {
        self.activityIndicator.startAnimating()
        UdacityData.getStudentLocations() { locations, error in
            self.mapView.removeAnnotations(self.annotations)
            self.annotations.removeAll()
            for dictionary in locations ?? [] {
                let lat = CLLocationDegrees(dictionary.latitude ?? 0.0)
                let long = CLLocationDegrees(dictionary.longitude ?? 0.0)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let first = dictionary.firstName
                let last = dictionary.lastName
                let mediaURL = dictionary.mediaURL
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = "\(String(describing: mediaURL))"
                self.annotations.append(annotation)
                self.activityIndicator.isHidden = true
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.annotations)
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "getStudentLocations"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let detailButton = PinButton(type: .detailDisclosure)
            detailButton.annotation = annotation
            detailButton.addTarget(self, action: #selector(pinButtonClicked), for: .touchUpInside)
            pinView?.rightCalloutAccessoryView = detailButton
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    @objc func pinButtonClicked(_ sender: PinButton) {
        guard let url = sender.annotation?.subtitle else { return  }
        userUrl(url!)
    }
    
}

class PinButton: UIButton {
    var annotation: MKAnnotation?
}
