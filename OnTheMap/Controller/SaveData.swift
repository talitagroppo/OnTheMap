//
//  SaveData.swift
//  OnTheMap
//
//  Created by Talita Groppo on 14/02/2022.
//

import Foundation

class SaveData {
    static private let identifier = "SaveData"
    var storage: UserDefaults
    
    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }
    
    func save(location: StudentsLocation) {
        if let objects = storage.object(forKey: SaveData.identifier) {
            var studentLocation = try? JSONDecoder().decode([StudentsLocation].self, from: objects as! Data)
            studentLocation?.append(location)
            let encode = try? JSONEncoder().encode(studentLocation)
            storage.set(encode, forKey: SaveData.identifier)
        } else {
            var studentLocations = [StudentsLocation]()
            studentLocations.append(location)
            let encode = try? JSONEncoder().encode(studentLocations)
            storage.set(encode, forKey: SaveData.identifier)
        }
    }
    
    func load() -> [StudentsLocation] {
        if let objects = storage.object(forKey: SaveData.identifier) {
            do {
                let studentsLocations = try JSONDecoder().decode([StudentsLocation].self, from: objects as! Data)
                return studentsLocations
            } catch {
                return [StudentsLocation]()
            }
        }
        return [StudentsLocation]()
    }
}
