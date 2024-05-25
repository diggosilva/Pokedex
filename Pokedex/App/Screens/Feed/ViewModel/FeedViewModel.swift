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
    private var pokemonList: [Pokemon] = []
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    
    func numberOfItemsInSection() -> Int {
        return pokemonList.count
    }
    
    func cellForItemAt(indexPath: IndexPath) -> Pokemon {
        return pokemonList[indexPath.row]
    }
    
    func loadDataPokemon() {
        self.service.getPokemons(url: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0") { pokemons in
            self.pokemonList = pokemons
            self.state.value = .loaded
        } onError: { error in
            self.state.value = .error
        }
    }
}
