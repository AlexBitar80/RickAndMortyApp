//
//  LocationTableViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 29/07/23.
//

import Foundation

struct LocationTableViewCellViewModel: Hashable, Equatable {
    
    private let location: Location
    
    init(location: Location) {
        self.location = location
    }
    
    var name: String {
        return location.name ?? ""
    }
    
    var type: String {
        return location.type ?? ""
    }
    
    var dimension: String {
        return location.dimension ?? ""
    }
    
    static func == (lhs: LocationTableViewCellViewModel, rhs: LocationTableViewCellViewModel) -> Bool {
        return lhs.location.id == rhs.location.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
        hasher.combine(type)
        hasher.combine(dimension)
    }
}
