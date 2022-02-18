//
//  GetLoggedInUserProfile.swift
//  OnTheMap
//
//  Created by Talita Groppo on 17/02/2022.
//

import Foundation

typealias Handler = (Result<StudentInformation, Error>) -> Void

class GetLoggedInUserProfile {
    var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func execute(completion: @escaping Handler) {
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(error!))
                return
            }
            let range = 5..<data!.count
            guard let newData = data?.subdata(in: range) else { fatalError() }
            do {
                let decoded = try JSONDecoder().decode(StudentInformation.self, from: newData)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
