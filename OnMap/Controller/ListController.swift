//
//  ListController.swift
//  OnMap
//
//  Created by KhoaLA8 on 4/4/24.
//

import Foundation
import UIKit

class ListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var students = StudentsData.sharedInstance().students
    let clientServices = ClientServices();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentsList()
    }
        
    func getStudentsList() {
        clientServices.getStudentLocations() {students, error in
            if let error {
                // Handle the case where the device is offline
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription, title: "Error")
                }
                return
            }
            self.students = students ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func addLatLongLocation(_ sender: Any) {
        addLocation()
    }
    
    @IBAction func logout(_ sender: Any) {
        clientServices.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func refreshList(_ sender: UIBarButtonItem) {
        getStudentsList()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomListViewCell") as! CustomListViewCell
        let student = self.students[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.customTitleLabel?.text = student.firstName + " " + student.lastName

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        openLink(student.mediaURL ?? "")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
