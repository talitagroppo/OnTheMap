//
//  PostSession.swift
//  OnTheMap
//
//  Created by Talita Groppo on 25/01/2022.
//

import Foundation

struct PostSession: Decodable {
    let account: [Account]
    let session: [Session]
}
class Account: Decodable {
    let registered: Bool
    let key: String
}
class Session: Decodable {
    let id: String
    let expiration: String
}
