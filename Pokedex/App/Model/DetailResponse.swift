//
//  DetailResponse.swift
//  Pokedex
//
//  Created by Diggo Silva on 27/05/24.
//

import Foundation

struct DetailResponse: Codable {
    let abilities: [Ability]
    let baseExperience: Int
    let height: Int
    let id: Int
    let name: String
    let species: Species
    let sprites: Sprites
    let stats: [Stat]
    let types: [TypeElement]
    let weight: Int

    enum CodingKeys: String, CodingKey {
        case abilities
        case baseExperience = "base_experience"
        case height
        case id
        case name
        case species
        case sprites, stats, types, weight
    }
    
    struct Stat: Codable {
        let baseStat: Int
        let stat: Species

        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case stat
        }
    }
    
    struct TypeElement: Codable {
        let type: Species
    }
    
    struct Ability: Codable {
        let ability: Species
    }

    struct Species: Codable {
        let name: String
        let url: String
    }

    struct Sprites: Codable {
        let other: Other?
    }

    struct Other: Codable {
        let officialArtwork: OfficialArtwork

        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }

    struct OfficialArtwork: Codable {
        let frontDefault: String

        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
}
