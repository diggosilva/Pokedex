//
//  Service.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import Foundation

protocol ServiceProtocol {
    func getPokemons(url: String) async throws -> (String?, [FeedModel])
    func getDetails(id: Int) async throws -> DetailModel
}

final class Service: ServiceProtocol {
    func getPokemons(url: String) async throws -> (String?, [FeedModel]) {
        guard let url = URL(string: url) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let response = response as? HTTPURLResponse {
            print("DEBUG: Statuscode.. \(response.statusCode)")
        }
        
        do {
            let feedResponse = try JSONDecoder().decode(FeedResponse.self, from: data)
            var feedModel: [FeedModel] = []
            let nextUrl = feedResponse.next
            
            for pokemon in feedResponse.results {
                feedModel.append(FeedModel(name: pokemon.name, url: pokemon.url))
            }
            return (nextUrl, feedModel)
        } catch {
            print("DEBUG: ERRO ao decodificar POKEMONS \(error.localizedDescription)")
            throw error
        }
    }
    
    func getDetails(id: Int) async throws -> DetailModel {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let response = response as? HTTPURLResponse {
            print("DEBUG: Statuscode.. \(response.statusCode)")
        }
        
        do {
            let detailsResponse = try JSONDecoder().decode(DetailResponse.self, from: data)
            var pokemonStats: [PokemonStats] = []
            
            for stat in detailsResponse.stats {
                pokemonStats.append(PokemonStats(base: Int(Double(stat.baseStat)), name: stat.stat.name))
            }
            let detailModel = DetailModel(
                name: detailsResponse.name,
                weight: Double(detailsResponse.weight),
                types: detailsResponse.types[0].type.name,
                stats: pokemonStats,
                image: detailsResponse.sprites.other?.officialArtwork.frontDefault ?? "",
                height: Double(detailsResponse.height)
            )
            return detailModel
        } catch {
            print("DEBUG: Erro aos decodificar DETALHES.. \(error.localizedDescription)")
            throw error
        }
    }
}
