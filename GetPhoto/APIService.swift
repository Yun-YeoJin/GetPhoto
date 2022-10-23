//
//  APIService.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/24.
//

import Foundation

import Foundation
import Alamofire

class APIService {
    
    static func randomPhoto(query: String, completion: @escaping (RandomPhoto?, Int?, Error?) -> Void) {
        let url = "\(EndPoint.randomPhotoURL)\(query)"
        let header: HTTPHeaders = ["Authorization": APIKey.unsplashKey]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: RandomPhoto.self) { response in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value): completion(value, statusCode, nil)
            case .failure(let error): completion(nil, statusCode, error)
            }
        }
    }
    
    private init() {
        
    }
}
