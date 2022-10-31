//
//  APIService.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/24.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case get(query: String)
    
    var baseURL: URL {
        return URL(string: EndPoint.searchURL + path)!
    }
    
    var header: HTTPHeaders {
        return ["Authorization": APIKey.unsplashKey]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .get(let query):
            return "\(query)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        return request
    }
}

class APIService {
    
    private init() { }
    
    static func fetchRandomPhoto(query: String, completion: @escaping (RandomPhoto?, Int?, Error?) -> Void) {
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
    
    static func fetchListPhoto(query: String, completion: @escaping ([ListPhoto]?, Int?, Error?) -> Void) {
        
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
    
    static func searchPhoto(query: String, completion: @escaping (Result<SearchPhoto, AFError>) -> Void) {
        
        
        AF.request(Router.get(query: query)).responseDecodable(of: SearchPhoto.self) { response in
            
            completion(response.result)
            
        }
        
//        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchPhoto.self) { response in
//            let statusCode = response.response?.statusCode
//
//            switch response.result {
//            case .success(let value): completion(value, statusCode, nil)
//            case .failure(let error): completion(nil, statusCode, error)
//            }
//        }
    }
    
    
}
