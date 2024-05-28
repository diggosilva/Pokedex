//
//  DetailModel.swift
//  Pokedex
//
//  Created by Diggo Silva on 27/05/24.
//

import Foundation

struct DetailModel {
    let name: String
    let weight: Double
    let types: String
    let stats: [PokemonStats]
    let image: String
    let height: Double
    
    var getWeight: String {
        return (weight/10).formatted() + " kg"
    }
    
    var getHeight: String {
        return (height*10).formatted() + " cm"
    }
}

struct PokemonType {
    let name: String
}

struct PokemonAbility {
    let name: String
}

struct PokemonStats {
    let base: Double
    let name: String
}
