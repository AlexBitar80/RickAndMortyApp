//
//  Episode.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 18/01/23.
//

import Foundation

struct Episode: Codable, EpisodeDataRender {
    let id: Int?
    let name: String?
    let air_date: String?
    let episode: String?
    let characters: [String]?
    let url: String?
    let created: String?
}
