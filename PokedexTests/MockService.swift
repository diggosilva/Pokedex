//
//  MockService.swift
//  PokedexTests
//
//  Created by Diggo Silva on 12/10/25.
//

import XCTest
import Combine
@testable import Pokedex

class Mock: ServiceProtocol {
    var isSuccess: Bool = true
    
    func getPokemons(url: String) async throws -> (String?, [FeedModel]) {
        if isSuccess {
            return ("", [
                FeedModel(name: "Pikachu", url: "www.pikachu.com"),
                FeedModel(name: "Bulbasaur", url: "www.bulbasaur.com"),
                FeedModel(name: "Charmander", url: "www.charmander.com"),
            ])
        } else {
            throw NSError(domain: "Error", code: 0, userInfo: nil)
        }
    }
    
    func getDetails(id: Int) async throws -> DetailModel {
        if isSuccess {
            return DetailModel(name: "Pikachu", weight: 60.0, types: "Electric", stats: [], image: "", height: 4.0)
        } else {
            throw NSError(domain: "Erro ao carregar Detalhes", code: 0, userInfo: nil)
        }
    }
}
