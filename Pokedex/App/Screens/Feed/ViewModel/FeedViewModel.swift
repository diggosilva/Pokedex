//
//  FeedViewModel.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import Foundation

protocol FeedViewModelProtocol {
    func numberOfItemsInSection() -> Int
    func cellForItemAt(indexPath: IndexPath) -> Pokemon
    func searchBar(textDidChange searchText: String)
    func loadDataPokemon()
    
    var state: Bindable<FeedViewControllerStates> { get set }
}

enum FeedViewControllerStates {
    case loading
    case loaded
    case error
}

class FeedViewModel: FeedViewModelProtocol {
    var state: Bindable<FeedViewControllerStates> = Bindable(value: .loading)
    private var service: ServiceProtocol = Service()
    private var pokemons: [Pokemon] = []
    private var filteredPokemons: [Pokemon] = []
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    
    func numberOfItemsInSection() -> Int {
        return filteredPokemons.count
    }
    
    func cellForItemAt(indexPath: IndexPath) -> Pokemon {
        return filteredPokemons[indexPath.row]
    }
    
    func searchBar(textDidChange searchText: String) {
        filteredPokemons = []
        
        if searchText.isEmpty {
            filteredPokemons = pokemons
        } else {
            for pokemon in pokemons {
                if pokemon.name.uppercased().contains(searchText.uppercased()) {
                    filteredPokemons.append(pokemon)
                }
            }
        }
    }
    
    func loadDataPokemon() {
        self.service.getPokemons(url: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0") { pokemons in
            self.pokemons = pokemons
            self.filteredPokemons = self.pokemons
            self.state.value = .loaded
        } onError: { error in
            self.state.value = .error
        }
    }
}
