//
//  LogoutUdacity.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import Foundation
import UIKit

class LogoutUdacity {
    
    func logoutUdacity(completion: @escaping (String) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error logging out.")
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            
            guard let decoded = try? JSONDecoder().decode(LogoutUdacityResult.self, from: newData!) else {
                print(String(data: data!, encoding: .utf8) as Any)
                return
            }
            completion(decoded.session.expiration)
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
}


