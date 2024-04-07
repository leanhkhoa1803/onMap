//
//  MapController.swift
//  OnMap
//
//  Created by KhoaLA8 on 30/3/24.
//

import Foundation
import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let clientServices = ClientServices();
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
        getLocationData()
    }
    
    @IBAction func addLatLongLocation(_ sender: Any) {
        addLocation()
    }
    
    func getLocationData(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        clientServices.getStudentLocations(){ locations,error in
            if let error {
                // Handle the case where the device is offline
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription, title: "Error")
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                return
            }
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
                annotation.subtitle = mediaURL
                self.annotations.append(annotation)
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.annotations)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
    @IBAction func logout(_ sender: Any) {
        self.activityIndicator.isHidden = true
        self.activityIndicator.startAnimating()
        
        clientServices.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = false
            }
        }
    }
    
    @IBAction func refreshMap(_ sender: Any) {
        getLocationData()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle {
                openLink(toOpen ?? "")
            }
        }
    }
}
