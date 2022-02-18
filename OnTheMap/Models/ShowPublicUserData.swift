//
//  ShowPublicUserData.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import Foundation
import UIKit

class ShowPublicUserData {
    func showPublicUserData(key: String, nickname: String, lastName: String, completion: @escaping(LoginUdacityResult?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/<user_id>")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"user\":  \"key\":\"\(key)\", \"nickname\":\"\(nickname)\",\"last_name\":\"\(lastName)\"}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, _, error in
          if error != nil {
              completion(nil)
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range)
            guard let decoded = try? JSONDecoder().decode(LoginUdacityResult.self, from: newData!) else {
                print(String(data: newData!, encoding: .utf8)!)
                completion(nil)
                return
            }
            completion(decoded)
        }
        task.resume()
    }
}
   

     
       
