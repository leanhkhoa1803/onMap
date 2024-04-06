//
//  AddLinkController.swift
//  OnMap
//
//  Created by KhoaLA8 on 4/4/24.
//

import Foundation
import UIKit
import MapKit


class AddLinkController : UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var textFieldLink: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var studentModel: StudentModel?
    let clientServices = ClientServices();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTextField()
        if var student = studentModel {
            showMapLocations(location: student)
        }
        submitButton.isEnabled = false
    }
    
    @IBAction func submitLocation(_ sender: Any) {
        studentModel?.mediaURL = textFieldLink.text
        if let studentLocation = studentModel {
            clientServices.addStudentLocation(information: studentLocation) { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "MapViewController", sender: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                    }
                }
            }
        }
    }
    
    @IBAction func cancelAddLocation(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showMapLocations(location: StudentModel) {
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = extractCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.firstName + location.lastName
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    private func extractCoordinate(location: StudentModel) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    
    func configTextField(){
        textFieldLink.delegate = self
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 30),
            .paragraphStyle: paragraphStyle
        ]
        textFieldLink.attributedPlaceholder = NSAttributedString(string: "Enter your link here", attributes: attributes)
        textFieldLink.tintColor = .white
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text != ""){
            submitButton.isEnabled = true;
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
        textField.becomeFirstResponder()
    }
}
