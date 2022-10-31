//
//  SearchPhotoViewModel.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/28.
//

import Foundation

import Alamofire
import RxCocoa
import RxSwift

class SearchPhotoViewModel {
    
    var photoList = BehaviorSubject(value: SearchPhoto(total: 0, totalPages: 0, results: []))
    
}

extension SearchPhotoViewModel {
    
    func requestSearchPhoto(query: String) {
        
        APIService.searchPhoto(query: query) { [weak self] (result: Result<SearchPhoto, AFError>) in
            guard let self = self else { return }

            switch result {
            case .success(let photo): self.photoList.onNext(photo)
            case .failure(let error): print(error.errorDescription!)
            }
        }
    }
}
