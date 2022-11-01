//
//  Photo.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/31.
//

import Foundation
import RealmSwift

class Photo: Object {
    @Persisted var photoID: String
    @Persisted var photoURL: String
    @Persisted var photoDescription: String
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(photoID: String, photoURL: String, photoDescription: String) {
        self.init()
        self.photoID = photoID
        self.photoURL = photoURL
        self.photoDescription = photoDescription
    }
    
}

class PhotoFolder: Object {
    
    @Persisted var folderName: String
    @Persisted var photoDetail: List<Photo>
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(folderName: String) {
        self.init()
        self.folderName = folderName
    }
}
