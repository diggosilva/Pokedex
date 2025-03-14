//
//  FeedViewModel.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import Foundation

protocol FeedViewModelProtocol {
    func numberOfItemsInSection() -> Int
    func cellForItemAt(indexPath: IndexPath) -> FeedModel
    func searchBar(textDidChange searchText: String)
    func collectionView(forItemAt indexPath: IndexPath)
    func loadDataPokemon()
}

enum FeedViewControllerStates {
    case loading
    case loaded
    case error
}

class FeedViewModel: FeedViewModelProtocol {
    private(set) var state: Bindable<FeedViewControllerStates> = Bindable(value: .loading)
    private var service: ServiceProtocol = Service()
    var pokemons: [FeedModel] = []
    var filteredPokemons: [FeedModel] = []
    var nextUrl: String?
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    
    func numberOfItemsInSection() -> Int {
        return filteredPokemons.count
    }
    
    func cellForItemAt(indexPath: IndexPath) -> FeedModel {
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
    
    func collectionView(forItemAt indexPath: IndexPath) {
        let lastIndexRow = numberOfItemsInSection()
        
        guard indexPath.row == lastIndexRow - 1 && filteredPokemons == pokemons, let nextUrl else { return }
        fetchRequest(url: nextUrl)
    }
    
    func loadDataPokemon() {
        fetchRequest(url: "https://pokeapi.co/api/v2/pokemon?limit=60&offset=0")
    }
    
    func fetchRequest(url: String) {
        service.getPokemons(url: url) { nextUrl, pokemons in
            self.nextUrl = nextUrl
            self.pokemons.append(contentsOf: pokemons)
            self.filteredPokemons.append(contentsOf: pokemons)
            self.state.value = .loaded
        } onError: { error in
            self.state.value = .error
        }
    }
}
