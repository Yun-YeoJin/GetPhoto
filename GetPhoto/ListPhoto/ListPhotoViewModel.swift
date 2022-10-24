//
//  ListPhotoViewModel.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/24.
//

import Foundation

class ListPhotoViewModel {
    
    var photoList: CObservable<[ListPhoto]> = CObservable([])
    
    func requestListPhoto(query: String) {
        
        APIService.fetchListPhoto(query: query) { photoList, statusCode, error in
            
            guard let photoList = photoList else { return }
            self.photoList.value = photoList
            
        }
        
    }
    
}
