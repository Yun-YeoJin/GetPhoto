//
//  APIService.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/24.
//

import Foundation
import Alamofire

class APIService {
    
    private init() { }
    
    static func requestRandomPhoto(query: String, completion: @escaping (RandomPhoto?, Int?, Error?) -> Void) {
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
    
    static func requestListPhoto(query: String, completion: @escaping ([ListPhoto]?, Int?, Error?) -> Void) {
        
        let url = "\(EndPoint.listURL)\(query)"
        let header: HTTPHeaders = ["Authorization": APIKey.unsplashKey]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: [ListPhoto].self) { response in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value): completion(value, statusCode, nil)
            case .failure(let error): completion(nil, statusCode, error)
            }
        }

    }
    
    
}
