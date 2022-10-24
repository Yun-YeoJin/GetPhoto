//
//  RandomPhoto.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/24.
//

import Foundation

// MARK: - RandomPhoto
struct RandomPhoto: Codable, Hashable {
    
    let id: String
    let altDescription: String
    let urls: RandomPhotoUrls
    let views, downloads: Int

    enum CodingKeys: String, CodingKey {
        case id
        case altDescription = "alt_description"
        case urls
        case views, downloads
    }
}

// MARK: - Urls
struct RandomPhotoUrls: Codable, Hashable {
    
    let raw, full, regular, small: String
    let thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
    
}

