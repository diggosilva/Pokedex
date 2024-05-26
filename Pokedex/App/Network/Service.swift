//
//  Service.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import Foundation

protocol ServiceProtocol {
    var dataTask: URLSessionDataTask? { get set }
    func getPokemons(url: String, onSuccess: @escaping(String?, [Pokemon]) -> Void, onError: @escaping(Error) -> Void)
}

final class Service: ServiceProtocol {
    var dataTask: URLSessionDataTask?
    
    func getPokemons(url: String, onSuccess: @escaping(String?, [Pokemon]) -> Void, onError: @escaping(Error) -> Void) {
        guard let url = URL(string: url) else { return }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    print("DEBUG: Status Code.. \(response.statusCode)")
                }
                
                do {
                    let pokemonResponse = try JSONDecoder().decode(PokemonResponse.self, from: data ?? Data())
                    var pokemons: [Pokemon] = []
                    let nextUrl = pokemonResponse.next
                    
                    for pokemon in pokemonResponse.results {
                        pokemons.append(Pokemon(name: pokemon.name, url: pokemon.url))
                    }
                    
                    onSuccess(nextUrl, pokemons)
                    print("DEBUG: SUCESSO ao decodificar POKEMONS \(pokemons)")
                } catch {
                    onError(error)
                    print("DEBUG: ERRO ao decodificar POKEMONS \(error.localizedDescription)")
                }
            }
        })
        dataTask?.resume()
    }
}
