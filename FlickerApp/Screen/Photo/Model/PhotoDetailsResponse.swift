//
//  PhotoDetailsResponse.swift
//  FlickerApp
//
//  Created by Shrikant Mundhe on 20/09/2022.
//

import Foundation

struct PhotoDetailsResponse: Codable {
    let photo : PhotoInfo?
    let stat: String?
}

struct PhotoInfo: Codable {
    let id: String?
    let secret: String?
    let server: String?
    let title: PhotoTitle?
    let description: Description?
    let dates: Dates?
    let urls: PhotoURLS?
}

struct PhotoURLS: Codable {
    let url: [PhotoURL]?
}

struct PhotoURL: Codable {
    let _content: String?
}


struct PhotoTitle: Codable {
    let _content: String?
}

struct Title: Codable {
    let _content: String?
}

struct Description: Codable {
    let _content: String?
}

struct Dates: Codable {
    let taken: String?
}
