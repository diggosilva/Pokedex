//
//  FeedViewModelTests.swift
//  PokedexTests
//
//  Created by Diggo Silva on 11/03/25.
//

import XCTest
@testable import Pokedex

class MockSuccess: ServiceProtocol {
    func getPokemons(url: String, onSuccess: @escaping (String?, [FeedModel]) -> Void, onError: @escaping (any Error) -> Void) {
        let pokemons: [FeedModel] = [
            FeedModel(name: "Pikachu", url: "www.pikachu.com"),
            FeedModel(name: "Bulbasaur", url: "www.bulbasaur.com"),
            FeedModel(name: "Charmander", url: "www.charmander.com"),
        ]
        onSuccess(nil, pokemons)
    }
    
    func getDetails(id: Int, onSuccess: @escaping (DetailModel) -> Void, onError: @escaping (any Error) -> Void) {}
}

class MockFailure: ServiceProtocol {
    func getPokemons(url: String, onSuccess: @escaping (String?, [Pokedex.FeedModel]) -> Void, onError: @escaping (any Error) -> Void) {
        onError(NSError(domain: "Falha ao carregar Pokemons", code: -1))
    }
    
    func getDetails(id: Int, onSuccess: @escaping (Pokedex.DetailModel) -> Void, onError: @escaping (any Error) -> Void) {}
}

final class PokedexTests: XCTestCase {
    var serviceProtocol: ServiceProtocol!
    var sut: FeedViewModel!
    
    override func setUp() {
        super.setUp()
        serviceProtocol = MockSuccess()
        sut = FeedViewModel(service: serviceProtocol)
    }
    
    //MARK: SUCCESS TESTS
    func testWhenSuccess() {
        sut.loadDataPokemon()
        
        let numberOfItems = sut.numberOfItemsInSection()
        XCTAssertEqual(numberOfItems, 3)
        
        let firstItem = sut.cellForItemAt(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(firstItem.name, "Pikachu")
        
        let lastItem = sut.cellForItemAt(indexPath: IndexPath(row: 2, section: 0))
        XCTAssertEqual(lastItem.url, "www.charmander.com")
        
        sut.state.value = .loaded
    }
    
    func testSearchBar() {
        sut.loadDataPokemon()
        
        sut.searchBar(textDidChange: "pik")
        
        XCTAssertEqual(sut.filteredPokemons.count, 1)
        XCTAssertEqual(sut.filteredPokemons.first?.name, "Pikachu")
        
        sut.searchBar(textDidChange: "")
        XCTAssertEqual(sut.filteredPokemons.count, 3)
    }
    
    func testCollectionViewLoadMore() {
        sut.loadDataPokemon()
        
        let expectation = self.expectation(description: "Fetch request chamada")
        
        sut.fetchRequest(url: "https://pokeapi.co/api/v2/pokemon?limit=60&offset=60")
        expectation.fulfill()
        
        sut.collectionView(forItemAt: IndexPath(row: sut.pokemons.count - 1, section: 0))
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    //MARK: FAILURE TESTS
    func testWhenFailure() {
        serviceProtocol = MockFailure()
        sut = FeedViewModel(service: serviceProtocol)
        
        sut.loadDataPokemon()
        XCTAssertEqual(sut.state.value, .error)
    }
    
    override func tearDown() {
        serviceProtocol = nil
        sut = nil
        super.tearDown()
    }
}
