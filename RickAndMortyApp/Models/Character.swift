//
//  Character.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 07/01/23.
//

import Foundation

struct Character: Codable {
    let id: Int?
    let name: String?
    let status: CharacterStatus?
    let species: String?
    let type: String?
    let gender: CharacterGender?
    let origin: CharaterOrigin?
    let location: SingleLocation?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}
