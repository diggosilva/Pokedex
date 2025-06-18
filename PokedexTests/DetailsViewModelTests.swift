//
//  DetailsViewModelTests.swift
//  PokedexTests
//
//  Created by Diggo Silva on 11/03/25.
//

import XCTest
import Combine
@testable import Pokedex

class MockServiceDetails: ServiceProtocol {
    var isSuccess: Bool = true
    
    func getPokemons(url: String) async throws -> (String?, [FeedModel]) {
        throw NSError(domain: "Error", code: 0, userInfo: nil)
    }
    
    func getDetails(id: Int) async throws -> DetailModel {
        if isSuccess {
            return DetailModel(name: "Pikachu", weight: 60.0, types: "Electric", stats: [], image: "", height: 4.0)
        } else {
            throw NSError(domain: "Erro ao carregar Detalhes", code: 0, userInfo: nil)
        }
    }
}

final class DetailsViewModelTests: XCTestCase {
    
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
        let mockServiceDetails = MockServiceDetails()
        let sut = DetailsViewModel(id: 1, service: mockServiceDetails)
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        
        sut.statePublisher
            .dropFirst() // Ignora o estado inicial `.loading`
            .receive(on: RunLoop.main)
            .sink { state in
                switch state {
                case .loaded(let detailModel):
                    XCTAssertEqual(detailModel.name, "Pikachu")
                    XCTAssertEqual(detailModel.weight, 60.0)
                    XCTAssertEqual(detailModel.types, "Electric")
                    XCTAssertEqual(detailModel.height, 4.0)
                    expectation.fulfill()
                case .error:
                    XCTFail( "Deveria ser .loaded, mas o estado deu .error")
                case .loading:
                    break // ignorar
                }
            }.store(in: &cancellables)
        
        sut.loadDataDetails()
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    //MARK: FAILURE TESTS
    func testWhenFailure() async throws {
        let mockServiceDetails = MockServiceDetails()
        mockServiceDetails.isSuccess = false
        
        let sut = DetailsViewModel(id: 25, service: mockServiceDetails)
        let expectation = XCTestExpectation(description: "State deveria ser .error")
        
        sut.statePublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { state in
                switch state {
                case .loading:
                    break
                case .loaded(_):
                    XCTFail("Deveria falhar, mas o estado deu Loaded")
                case .error:
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.loadDataDetails()
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
}
