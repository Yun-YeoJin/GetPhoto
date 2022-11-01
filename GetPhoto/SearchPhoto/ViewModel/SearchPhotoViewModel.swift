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
    
    let repository = PhotoFolderRepository()
    
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
    
    func addFolder(item: SearchResult, text: String) {
        
        if repository.fetchFolderFilter(text: text).isEmpty { //PhotoListTable이 비어있으면
            
            let task = PhotoFolder(folderName: text)
            task.photoDetail.append(Photo(photoID: item.id, photoURL: item.links.downloadLocation, photoDescription: item.resultDescription ?? text))
            do {
                try repository.addFolder(item: task)
            } catch {
                print("error")
            }
            
        } else { //PhotoListTable이 안비어있으면
            
            guard let folder = repository.fetchFolderFilter(text: text).first else {return}
            let item = Photo(photoID: item.id, photoURL: item.links.downloadLocation, photoDescription: item.resultDescription ?? text)
            do {
                try repository.appendPhoto(folder: folder, item: item)
            } catch {
                print("error")
            }
        }
    }
}
