//
//  PhotoRepository.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/31.
//

import Foundation
import RealmSwift

protocol PhotoRepository {
    func fetchPhoto() -> Results<Photo>
    func fetchFolder() -> Results<PhotoFolder>
    func appendPhoto(folder: PhotoFolder, item: Photo) throws
    func fetchFolderFilter(text: String) -> Results<PhotoFolder>
    func addFolder(item: PhotoFolder) throws
}

class PhotoFolderRepository: PhotoRepository {
    
    let config = Realm.Configuration(schemaVersion: 1)
    
    lazy var localRealm = try! Realm(configuration: config)
    
    func fetchPhoto() -> Results<Photo> {
        return localRealm.objects(Photo.self)
    }
    
    func fetchFolder() -> Results<PhotoFolder> {
        return localRealm.objects(PhotoFolder.self)
    }
    
    func appendPhoto(folder: PhotoFolder, item: Photo) throws {
        try localRealm.write {
            folder.photoDetail.append(item)
        }
    }
    
    func fetchFolderFilter(text: String) -> Results<PhotoFolder> {
        return localRealm.objects(PhotoFolder.self).filter("folderName == %@", text)
    }
    
    func addFolder(item: PhotoFolder) throws {
        try localRealm.write {
            localRealm.add(item)
        }
    }
    
    
}
