//
//  GetAllEpisodesResponse.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 02/03/23.
//

import Foundation

struct GetAllEpisodesResponse: Codable {
    let info: GetAllEpisodesResponseInfo
    let results: [Episode]
}

struct GetAllEpisodesResponseInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
