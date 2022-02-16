//
//  ShowPublicUserData.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import Foundation
import UIKit

class ShowPublicUserData {
    func showPublicUserData() {
        
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/3903878747")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
               return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) 
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
}

