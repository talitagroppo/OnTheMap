//
//  UdacityData.swift
//  OnTheMap
//
//  Created by Talita Groppo on 09/02/2022.
//

import Foundation
import UIKit


class UdacityData: NSObject {
    
    struct Auth {
        static var sessionId: String? = nil
        static var key = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
        static var mediaURL = ""
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocations
        case addLocation
        case updateLocation
        case getLoggedInUserProfile(String)
        
        var stringValue: String {
            switch self {
            case .getStudentLocations:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .addLocation:
                return Endpoints.base + "/StudentLocation"
            case .updateLocation:
                return Endpoints.base + "/StudentLocation/" + Auth.objectId
            case .getLoggedInUserProfile (let uniqueKey):
                return Endpoints.base + "/users/" + uniqueKey
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    override init() {
        super.init()
    }
    
    class func shared() -> UdacityData {
        
        struct GetInfo {
            static var shared = UdacityData()
        }
        return GetInfo.shared
    }
    
    class func getLoggedInUserProfile(completion: @escaping (Bool, Error?) -> Void) {
        DispatchQueue.main.async {
            guard let uniqueKey = (UIApplication.shared.delegate as? AppDelegate)?.uniqueKey else { fatalError() }
            DispatchQueue.global(qos: .utility).async {
                RequestHelpers.taskForGETRequest(url: Endpoints.getLoggedInUserProfile(uniqueKey).url, apiType: "Udacity", responseType: StudentInformation.self) { (response, error) in
                    if let response = response {
                        print(response)
                        completion(true, nil)
                    } else {
                        print("Failed to get user's profile.")
                        completion(false, error)
                    }
                }
            }
        }
    }
    
    
    class func logout(completion: @escaping () -> Void) {
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
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error logging out.")
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }
    
    
    class func getStudentLocations(completion: @escaping ([StudentInformation]?, Error?) -> Void) {
        RequestHelpers.taskForGETRequest(url: Endpoints.getStudentLocations.url, apiType: "Parse", responseType: StudentsLocation.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    
    class func addStudentLocation(information: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        print(information)
        let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}"
        RequestHelpers.taskForPOSTRequest(
            url: Endpoints.addLocation.url,
            apiType: "Parse",
            responseType: PostLocation.self,
            body: body,
            httpMethod: "POST"
        ) { (response, error) in
            if let response = response, response.createdAt != nil {
                Auth.objectId = response.objectId ?? ""
                completion(true, nil)
                return
            }
            completion(false, error)
        }
    }
    
    class func updateStudentLocation(completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"uniqueKey\", \"firstName\": \"firstName\", \"lastName\": \"lastName\",\"mapString\": \"mapString\", \"mediaURL\": \"mediaURL\",\"latitude\": latitude, \"longitude\": longitude}"
        RequestHelpers.taskForPOSTRequest(url: Endpoints.updateLocation.url, apiType: "Parse", responseType: UpdateLocationResponse.self, body: body, httpMethod: "PUT") { (response, error) in
            if let response = response, response.updatedAt != nil {
                completion(true, nil)
            }
            completion(false, error)
        }
    }
    
}
