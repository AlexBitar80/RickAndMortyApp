//
//  GetLocationsResponse.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 28/07/23.
//

import Foundation

struct GetAllLocationsResponse: Codable {
    let info: GetAllLocationsResponseInfo
    let results: [Location]
}

struct GetAllLocationsResponseInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
