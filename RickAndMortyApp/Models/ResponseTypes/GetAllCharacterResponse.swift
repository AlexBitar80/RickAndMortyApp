//
//  GetCharacterResponse.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 23/01/23.
//

import Foundation

struct GetAllCharacterResponse: Codable {
    let info: GetAllCharacterResponseInfo?
    let results: [MRCharacter]?
}

struct GetAllCharacterResponseInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

