//
//  DeleteSession.swift
//  OnTheMap
//
//  Created by Talita Groppo on 25/01/2022.
//

import Foundation

class DeleteSession: Decodable {
        var id: String
        var expiration: String
}
struct ResultOfDeleteSession: Decodable {
    let session: [DeleteSession]
}
