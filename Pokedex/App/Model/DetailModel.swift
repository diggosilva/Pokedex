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
    
    var getAttack: Int {
        var attack: Int?
        for stat in stats {
            if stat.name == "attack" {
                attack = stat.base
            }
        }
        return attack ?? 0
    }
    
    var getHP: Int {
        stats.first(where: { $0.name == "hp" })?.base ?? 0
    }
    
    var getDefense: Int {
        stats.first(where: { $0.name == "defense" })?.base ?? 0
    }
    
    var getSpecialAttack: Int {
        stats.first(where: { $0.name == "special-attack" })?.base ?? 0
    }
    
    var getSpecialDefense: Int {
        stats.first(where: { $0.name == "special-defense" })?.base ?? 0
    }
    
    var getSpeed: Int {
        stats.first(where: { $0.name == "speed" })?.base ?? 0
    }
}

struct PokemonType {
    let name: String
}

struct PokemonAbility {
    let name: String
}

struct PokemonStats {
    let base: Int
    let name: String
}
