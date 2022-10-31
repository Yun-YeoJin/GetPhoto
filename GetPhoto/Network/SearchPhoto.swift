//
//  SearchPhoto.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/28.
//

import Foundation

struct SearchPhoto: Codable, Hashable {
     
    let total, totalPages: Int
    var results: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct SearchResult: Codable, Hashable {
     
    let id: String
    let resultDescription: String?
    let urls: Urls
    let links: Links
    let likes: Int

    enum CodingKeys: String, CodingKey {
        case id
        case urls, likes, links
        case resultDescription = "description"

    }
}

// MARK: - Urls
struct Urls: Codable, Hashable {
    let raw, full, regular, small: String
    let thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}

// MARK: - Links
struct Links: Codable, Hashable {
    let html, download, downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case html, download
        case downloadLocation = "download_location"
    }
}
