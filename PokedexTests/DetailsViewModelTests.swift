//
//  DetailsViewModelTests.swift
//  PokedexTests
//
//  Created by Diggo Silva on 11/03/25.
//

import XCTest
import Combine
@testable import Pokedex

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
        let mockService = MockService()
        let sut = DetailsViewModel(id: 1, service: mockService)
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
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    //MARK: FAILURE TESTS
    func testWhenFailure() async throws {
        let mockService = MockService()
        mockService.isSuccess = false
        
        let sut = DetailsViewModel(id: 25, service: mockService)
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
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
