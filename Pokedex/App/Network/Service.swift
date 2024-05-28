//
//  Service.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import Foundation

protocol ServiceProtocol {
    func getPokemons(url: String, onSuccess: @escaping(String?, [FeedModel]) -> Void, onError: @escaping(Error) -> Void)
    func getDetails(id: Int, onSuccess: @escaping(DetailModel) -> Void, onError: @escaping(Error) -> Void)
}

final class Service: ServiceProtocol {
    private var dataTask: URLSessionDataTask?
    
    func getPokemons(url: String, onSuccess: @escaping(String?, [FeedModel]) -> Void, onError: @escaping(Error) -> Void) {
        guard let url = URL(string: url) else { return }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    print("DEBUG: Status Code.. \(response.statusCode)")
                }
                do {
                    let feedResponse = try JSONDecoder().decode(FeedResponse.self, from: data ?? Data())
                    var feedModel: [FeedModel] = []
                    let nextUrl = feedResponse.next
                    
                    for pokemon in feedResponse.results {
                        feedModel.append(FeedModel(name: pokemon.name, url: pokemon.url))
                    }
                    onSuccess(nextUrl, feedModel)
                } catch {
                    onError(error)
                    print("DEBUG: ERRO ao decodificar POKEMONS \(error.localizedDescription)")
                }
            }
        })
        dataTask?.resume()
    }
    
    func getDetails(id: Int, onSuccess: @escaping(DetailModel) -> Void, onError: @escaping(Error) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else { return }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let detailsResponse = try JSONDecoder().decode(DetailResponse.self, from: data)
                        var pokemonStats: [PokemonStats] = []
                        
                        for stat in detailsResponse.stats {
                            pokemonStats.append(PokemonStats(base: Double(stat.baseStat), name: stat.stat.name))
                        }
                        let detailModel = DetailModel(
                            name: detailsResponse.name,
                            weight: Double(detailsResponse.weight),
                            types: detailsResponse.types[0].type.name,
                            stats: pokemonStats,
                            image: detailsResponse.sprites.other?.officialArtwork.frontDefault ?? "",
                            height: Double(detailsResponse.height)
                        )
                        onSuccess(detailModel)
                    } catch {
                        onError(error)
                        print("DEBUG: Erro aos decodificar DETALHES.. \(error.localizedDescription)")
                    }
                }
            }
        })
        dataTask?.resume()
    }
}
