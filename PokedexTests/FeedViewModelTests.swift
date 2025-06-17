//
//  FeedViewModelTests.swift
//  PokedexTests
//
//  Created by Diggo Silva on 11/03/25.
//

import XCTest
import Combine
@testable import Pokedex

class MockService: ServiceProtocol {
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
        throw NSError(domain: "Error", code: 0, userInfo: nil)
    }
}

final class PokedexTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    //MARK: SUCCESS TESTS
    func testWhenSuccess() async throws {
        let mockService = MockService()
        let sut = FeedViewModel(service: mockService)
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        
        sut.statePublisher
            .receive(on: RunLoop.main)
            .sink { state in
                if state == .loaded {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.loadDataPokemon()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        let numberOfItems = sut.numberOfItemsInSection()
        XCTAssertEqual(numberOfItems, 3)
        
        let firstItem = sut.cellForItemAt(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(firstItem.name, "Pikachu")
        
        let lastItem = sut.cellForItemAt(indexPath: IndexPath(row: 2, section: 0))
        XCTAssertEqual(lastItem.url, "www.charmander.com")
    }
    
    func testWhenSuccessWithFailureHandling() async throws {
        let mockService = MockService()
        mockService.isSuccess = false
        
        let sut = FeedViewModel(service: mockService)
        let expectation = XCTestExpectation(description: "State deveria ser .error")
        
        sut.statePublisher
            .receive(on: RunLoop.main)
            .sink { state in
                if state == .error {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.loadDataPokemon()
        
        await fulfillment(of: [expectation], timeout: 2.0)
                
        XCTAssertEqual(sut.numberOfItemsInSection(), 0)
        XCTAssertEqual(sut.pokemons.count, 0)
        XCTAssertEqual(sut.filteredPokemons.count, 0)
    }
    
    func testSearchBar() async throws {
        let mockService = MockService()
        let sut = FeedViewModel(service: mockService)
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        
        sut.statePublisher
            .receive(on: RunLoop.main)
            .sink { state in
                if state == .loaded {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.loadDataPokemon()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        sut.searchBar(textDidChange: "pik")
        
        XCTAssertEqual(sut.filteredPokemons.count, 1)
        XCTAssertEqual(sut.filteredPokemons.first?.name, "Pikachu")
        
        sut.searchBar(textDidChange: "")
        XCTAssertEqual(sut.filteredPokemons.count, 3)
    }
    
    func testCollectionViewLoadMore() async throws {
        let mockService = MockService()
        let sut = FeedViewModel(service: mockService)
        
        var loadCount = 0
        let expectation = XCTestExpectation(description: "Deve carregar dados duas vezes (load more)")
        expectation.expectedFulfillmentCount = 2 // <- Espera dois carregamentos

        sut.statePublisher
            .receive(on: RunLoop.main)
            .sink { state in
                if state == .loaded {
                    loadCount += 1
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.loadDataPokemon() // Primeira carga
        await Task.yield()
        
        sut.nextUrl = "https://pokeapi.co/api/v2/pokemon?limit=60&offset=60"
        sut.collectionView(forItemAt: IndexPath(row: sut.pokemons.count - 1, section: 0)) // Carrega mais
        
        await fulfillment(of: [expectation], timeout: 3.0)
        
        // Agora que ambos os carregamentos aconteceram, esses acessos são seguros
        XCTAssertEqual(sut.pokemons.count, 6)
        XCTAssertEqual(sut.filteredPokemons.count, 6)
        
        let lastItem = sut.cellForItemAt(indexPath: IndexPath(row: 5, section: 0))
        XCTAssertEqual(lastItem.name, "Charmander")
    }

    
    //MARK: FAILURE TESTS
    func testWhenFailure() async throws {
        let mockService = MockService()
        mockService.isSuccess = false
        
        let sut = FeedViewModel(service: mockService)
        let expectation = XCTestExpectation(description: "State deveria ser .error")
        
        sut.statePublisher
            .receive(on: RunLoop.main)
            .sink { state in
                if state == .error {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.loadDataPokemon()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
    }
    
    func testWhenFailureWithSuccessHandling() async throws {
        let mockService = MockService()
        let sut = FeedViewModel(service: mockService)
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        
        sut.statePublisher
            .receive(on: RunLoop.main)
            .sink { state in
                if state == .loaded {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.loadDataPokemon()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertEqual(sut.filteredPokemons.count, 3)
        XCTAssertEqual(sut.filteredPokemons.first?.name, "Pikachu")
    }
}
