//
//  PokemonResponse.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import Foundation

struct PokemonResponse: Codable {
    let next: String?
    let results: [Result]
    
    struct Result: Codable {
        let name: String
        let url: String
    }
}
