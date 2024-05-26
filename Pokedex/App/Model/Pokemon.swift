//
//  Pokemon.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import Foundation

struct Pokemon: Equatable {
    let name: String
    let url: String
    
    var imageUrl: String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(getId).png"
    }
    
    var getId: Int {
        var id = url.components(separatedBy: "https://pokeapi.co/api/v2/pokemon/").last ?? ""
        id = String(id.dropLast())
        return Int(id) ?? 0
    }
}
