//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import UIKit
import CoreLocation

class ListViewController: UITableViewController {
    
    static var identifier = "cell"

    @IBOutlet var tableViewList: UITableView!
    
    var students = [StudentInformation]()
    
      override func viewDidLoad() {
          super.viewDidLoad()
          tableViewList.delegate = self
          tableViewList.dataSource = self
      }
      
      override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(true)
          allLocations = saveData.load()
          tableViewList.reloadData()
          getStudentsList()
      }
    
    
    @IBAction func addNewData(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: AddListViewController.identifier) as! AddListViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    let saveData = SaveData()
    
    lazy var allLocations: [StudentsLocation] = {
        return saveData.load()
    }()
    
      @IBAction func logout(_ sender: UIBarButtonItem) {
          let vc = LoginViewController()
          UdacityData.logout {
              DispatchQueue.main.async {
                  self.dismiss(animated: true, completion: nil)
              }
          }
          navigationController?.pushViewController(vc, animated: true)
      }
      
      @IBAction func refreshList(_ sender: UIBarButtonItem) {
          getStudentsList()
      }
      
      func getStudentsList() {
          UdacityData.getStudentLocations() {students, error in
              self.students = students ?? []
              DispatchQueue.main.async {
                  self.tableViewList.reloadData()
              }
          }
      }

    override func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return students.count
      }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListViewController.identifier, for: indexPath)
          let student = students[indexPath.row]
        cell.textLabel?.text = "        \(student.firstName)" + " " + "\(student.lastName)"
          cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"
          return cell
      }
      
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let student = students[indexPath.row]
        userUrl(student.mediaURL ?? "")
      }
  }
