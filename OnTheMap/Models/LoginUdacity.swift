//
//  LoginUdacity.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import Foundation
import UIKit

class LoginUdacity {
    func execute(email: String, password: String, completion: @escaping (Bool) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, _, error in
            if error != nil {
                completion(false)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            
            guard let decoded = try? JSONDecoder().decode(LoginUdacityResult.self, from: newData!) else {
                print(String(data: data!, encoding: .utf8) as Any)
                completion(false)
                return
            }
            completion(decoded.account.registered)
        }
        task.resume()
    }
}

