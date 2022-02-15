//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Talita Groppo on 25/01/2022.
//

import Foundation
import SwiftUI

class StudentLocation: Decodable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}

struct Results: Decodable {
    var results: [StudentLocation]
}

