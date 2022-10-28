//
//  SearchPhotoViewModel.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/28.
//

import Foundation

class SearchPhotoViewModel {
    
    var photoList: CObservable<SearchPhoto> = CObservable(SearchPhoto(total: 0, totalPages: 0, results: []))
    
    func requestSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) { photo, statusCode, error in
            guard let photo = photo else { return }
            self.photoList.value = photo
        }
    }
    
}
