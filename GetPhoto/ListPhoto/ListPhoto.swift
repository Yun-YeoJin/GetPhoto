//
//  ListPhoto.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/24.
//

import Foundation

struct ListPhoto: Codable, Hashable {
    
    let id: String
    let urls: ListPhotoUrls
    let likes: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case urls, likes
    }
}

struct ListPhotoUrls: Codable, Hashable {
    let raw, full, regular, small: String
    let thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
