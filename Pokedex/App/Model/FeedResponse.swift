//
//  FeedResponse.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import Foundation

struct FeedResponse: Codable {
    let next: String?
    let results: [NameURLModel]
    
    struct NameURLModel: Codable {
        let name: String
        let url: String
    }
}
