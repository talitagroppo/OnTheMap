//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import Foundation

struct StudentInformation: Codable {
    var createdAt: String?
    var firstName: String
    var lastName: String
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
    
    init(
        createdAt: String? = nil,
        firstName: String,
        lastName: String,
        latitude: Double? = nil,
        longitude: Double? = nil,
        mapString: String? = nil,
        mediaURL: String? = nil,
        objectId: String? = nil,
        uniqueKey: String? = nil,
        updatedAt: String? = nil
    ) {
        self.createdAt = createdAt
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.updatedAt = updatedAt
    }
    
    init(_ dictionary: [String: AnyObject]) {
        self.createdAt = dictionary["createdAt"] as? String
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        self.objectId = dictionary["objectId"] as? String
        self.updatedAt = dictionary["updatedAt"] as? String
    }
    
    var labelName: String {
        var name = ""
        if !firstName.isEmpty {
            name = firstName
        }
        if !lastName.isEmpty {
            if name.isEmpty {
                name = lastName
            } else {
                name += " \(lastName)"
            }
        }
        if name.isEmpty {
            name = "FirstName LastName"
        }
        return name
    }
 
}
