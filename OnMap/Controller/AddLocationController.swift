//
//  AddLocationController.swift
//  OnMap
//
//  Created by KhoaLA8 on 4/4/24.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationController : UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var auth = AuthModel(key: "", firstName: "", lastName: "", objectId: "")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var coordinate = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findButton.isEnabled = false;
        activityIndicator.isHidden = true
        configTextField()
        auth = initAppDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func findLocation(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        CLGeocoder().geocodeAddressString(textFieldLocation.text!) { (newMarker, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription, title: "Location Not Found")
                print("Location not found.")
            } else {
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.coordinate = location.coordinate
                    self.loadNewLocation()
                }
            }
        }
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func loadNewLocation() {
        performSegue(withIdentifier: "ShowAddLink", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddLink" {
            if let addLinkController = segue.destination as? AddLinkController {
                addLinkController.studentModel = buildStudentInfo(coordinate)
            }
        }
    }
    
    private func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentModel {
        
        var studentInfo = [
            "uniqueKey": auth.key,
            "firstName": auth.firstName,
            "lastName": auth.lastName,
            "mapString": textFieldLocation.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            "objectId":auth.objectId
            ] as [String: AnyObject]
        
        return StudentModel(studentInfo)

    }
    
    @IBAction func cancelAddLocation(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configTextField(){
        textFieldLocation.delegate = self
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 30),
            .paragraphStyle: paragraphStyle
        ]
        textFieldLocation.attributedPlaceholder = NSAttributedString(string: "Enter your location here", attributes: attributes)
        textFieldLocation.tintColor = .white
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.text != ""){
            findButton.isEnabled = true;
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
        textField.becomeFirstResponder()
    }
}
