//
//  LogoutUdacityResult.swift
//  OnTheMap
//
//  Created by Talita Groppo on 07/02/2022.
//

import Foundation
import UIKit

struct LogoutUdacityResult: Decodable {
    
    var account: Account
    
    var session: Session
    
    struct Account: Decodable {
        var registered: Bool
        var key: String
    }
    struct Session: Decodable {
        var id: String
        var expiration: String
    }
}

