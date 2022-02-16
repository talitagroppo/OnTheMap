//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var addNewLocation: UIBarButtonItem!
    
    var locations = [StudentInformation]()
    
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentsPins()
        navigationController?.navigationBar.isHidden = false
    }
    @IBAction func addNewLocation(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: AddListViewController.identifier) as! AddListViewController
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
            self.locations = locations ?? []
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
                annotation.subtitle = mediaURL
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
            let detailButton = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = detailButton
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let studentLocation = view.annotation as? UdacityData else {return}
        let studentInfo = studentLocation
        let alert = UIAlertController(title: ("\(studentInfo)"), message: "\(UdacityData.Auth.mediaURL)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        if control == view.rightCalloutAccessoryView {
            if let userURL = view.annotation?.subtitle{
                userUrl(userURL ?? "")
            }
        }
    }
    
}
