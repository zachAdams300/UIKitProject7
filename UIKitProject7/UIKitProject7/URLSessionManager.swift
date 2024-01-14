//
//  URLSessionManager.swift
//  UIKitProject7
//
//  Created by Zachary Adams on 1/13/24.
//

import Foundation

enum DataError: Error {
    case ServerError
    case DecodeError
}

class URLSessionManager {
    
    static let shared = URLSessionManager()
    
    private init() {
        
    }
    
    func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200 ..< 299).contains(httpResponse.statusCode) else {
                completion(.failure(DataError.ServerError))
                
                return
            }
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            }catch {
                completion(.failure(DataError.DecodeError))
            }
            
        }.resume()
    }
}
