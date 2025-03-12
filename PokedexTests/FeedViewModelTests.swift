//
//  FeedViewModelTests.swift
//  PokedexTests
//
//  Created by Diggo Silva on 11/03/25.
//

import XCTest
@testable import Pokedex

class MockSuccess: ServiceProtocol {
    func getPokemons(url: String, onSuccess: @escaping (String?, [FeedModel]) -> Void, onError: @escaping (Error) -> Void) {
        let pokemons: [FeedModel] = [
            FeedModel(name: "Pikachu", url: "www.pikachu.com"),
            FeedModel(name: "Bulbasaur", url: "www.bulbasaur.com"),
            FeedModel(name: "Charmander", url: "www.charmander.com"),
        ]
        onSuccess(nil, pokemons)
    }
    
    func getDetails(id: Int, onSuccess: @escaping (DetailModel) -> Void, onError: @escaping (Error) -> Void) {}
}

class MockFailure: ServiceProtocol {
    func getPokemons(url: String, onSuccess: @escaping (String?, [FeedModel]) -> Void, onError: @escaping (Error) -> Void) {
        onError(NSError(domain: "Falha ao carregar Pokemons", code: -1))
    }
    
    func getDetails(id: Int, onSuccess: @escaping (DetailModel) -> Void, onError: @escaping (Error) -> Void) {}
}

final class PokedexTests: XCTestCase {
    
    //MARK: SUCCESS TESTS
    func testWhenSuccess() {
        let sut = FeedViewModel(service: MockSuccess())
        sut.loadDataPokemon()
        
        let numberOfItems = sut.numberOfItemsInSection()
        XCTAssertEqual(numberOfItems, 3)
        
        let firstItem = sut.cellForItemAt(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(firstItem.name, "Pikachu")
        
        let lastItem = sut.cellForItemAt(indexPath: IndexPath(row: 2, section: 0))
        XCTAssertEqual(lastItem.url, "www.charmander.com")
        
        sut.state.value = .loaded
    }
    
    func testWhenSuccessWithFailureHandling() {
        let sut = FeedViewModel(service: MockFailure())
        sut.loadDataPokemon()
                
        XCTAssertEqual(sut.state.value, .error)
        XCTAssertEqual(sut.numberOfItemsInSection(), 0)
        
        XCTAssertEqual(sut.pokemons.count, 0)
        XCTAssertEqual(sut.filteredPokemons.count, 0)
    }
    
    func testSearchBar() {
        let sut = FeedViewModel(service: MockSuccess())
        sut.loadDataPokemon()
        sut.searchBar(textDidChange: "pik")
        
        XCTAssertEqual(sut.filteredPokemons.count, 1)
        XCTAssertEqual(sut.filteredPokemons.first?.name, "Pikachu")
        
        sut.searchBar(textDidChange: "")
        XCTAssertEqual(sut.filteredPokemons.count, 3)
    }
    
    func testCollectionViewLoadMore() {
        // 1. Criando o serviço mock para simular sucesso no carregamento de dados
        let sut = FeedViewModel(service: MockSuccess())

        // 2. Carregar dados iniciais
        sut.loadDataPokemon()
        
        // 3. Verificando se os dados iniciais foram carregados corretamente
        XCTAssertEqual(sut.pokemons.count, 3) // Inicialmente, 3 pokémons devem ser carregados
        XCTAssertEqual(sut.filteredPokemons.count, 3) // Verifica se a lista filtrada também contém 3 itens

        // 4. Simula o carregamento de mais dados
        let nextUrl = "https://pokeapi.co/api/v2/pokemon?limit=60&offset=60"
        sut.nextUrl = nextUrl // Atualizando o próximo URL que será usado no "load more"
        
        // 5. Chama a função de "scroll" até o final
        sut.collectionView(forItemAt: IndexPath(row: sut.pokemons.count - 1, section: 0))
        
        // 6. Verificando se o método fetchRequest foi chamado e mais dados foram carregados
        // Como o MockSuccess já está controlando o fluxo, podemos verificar diretamente os dados
        XCTAssertEqual(sut.pokemons.count, 6) // Espera-se que agora haja 6 pokémons (3 iniciais + 3 carregados)
        XCTAssertEqual(sut.filteredPokemons.count, 6) // Também a lista filtrada deve ter 6 elementos
        
        let lastItem = sut.cellForItemAt(indexPath: IndexPath(row: 5, section: 0))
        XCTAssertEqual(lastItem.name, "Charmander")
    }
    
    //MARK: FAILURE TESTS
    func testWhenFailure() {
        let sut = FeedViewModel(service: MockFailure())
        
        sut.loadDataPokemon()
        XCTAssertEqual(sut.state.value, .error)
    }
    
    func testWhenFailureWithSuccessHandling() {
        let sut = FeedViewModel(service: MockSuccess())
        
        sut.loadDataPokemon()
        
        XCTAssertEqual(sut.state.value, .loaded)
        
        XCTAssertEqual(sut.filteredPokemons.count, 3)
        XCTAssertEqual(sut.filteredPokemons.first?.name, "Pikachu")
    }
}
