////
////  GetStudentLocation.swift
////  OnTheMap
////
////  Created by Talita Groppo on 07/02/2022.
////
//
//import Foundation
//import UIKit
//
//class GetStudentLocation {
//    
//    var listCell = ListCell()
//    
//    var tableVieew = ListViewController()
//
//    func getStudentLocation(
////        createdAt: String, firstName: String, lastName: String, mapString: String, mediaURL: String, objectID: String, uniqueKey: String, updatedAt: String, completion: @escaping(Bool) -> Void
//    ){
//        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = "{\"udacity\": {\"createdAt\": \"\(String(describing: listCell.createdAt))\", \"firstName\": \"\(String(describing: listCell.firstName))\", \"lastName\": \"\(String(describing: listCell.lastName))\", \"mapString\": \"\(String(describing: listCell.mapString))\", \"mediaURL\": \"\(String(describing: listCell.mediaURL))\", \"objectID\": \"\(String(describing: listCell.objectId))\", \"uniqueKey\": \"\(String(describing: listCell.uniqueKey))\", \"updatedAt\": \"\(String(describing: listCell.updatedAt))\"}}".data(using: .utf8)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, _, error in
//            if error != nil {
//                
//                return
//            }
//        }
//        task.resume()
//    }
//    func getStudentsList() {
//        self.getStudentLocation()
////        getStudentLocation(createdAt: listCell.createdAt.text ?? "Not found", firstName: listCell.firstName.text ?? "Not found", lastName: listCell.lastName.text ?? "Not found", mapString: listCell.mapString.text ?? "Not found", mediaURL: listCell.mediaURL.text ?? "Not found", objectID: listCell.objectId.text ?? "Not found", uniqueKey: listCell.uniqueKey.text ?? "Not found", updatedAt: listCell.updatedAt.text ?? "Not found") { _ in
////        let createAt = listCell.createdAt.text
////        let firstName = listCell.firstName.text
////        let lastName = listCell.lastName.text
////        let mapString = listCell.mapString.text
////        let mediaURL = listCell.mediaURL.text
////        let objectID = listCell.objectId.text
////        let uniqueKey = listCell.uniqueKey.text
////        let updatedAt = listCell.updatedAt.text
//
//            DispatchQueue.main.async {
//                self.tableVieew.tableView.reloadData()
//        }
//    }
//}
//
//struct UpdateAt: Decodable {
//    let updatedAt: String?
//}
