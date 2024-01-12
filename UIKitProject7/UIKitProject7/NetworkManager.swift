//
//  NetworkManager.swift
//  UIKitProject7
//
//  Created by Zachary Adams on 1/12/24.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {
        
    }
    
    func request<T: Decodable>(_ url: String, method: HTTPMethod, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url, method: method, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
