//
//  DetailsViewModelTests.swift
//  PokedexTests
//
//  Created by Diggo Silva on 11/03/25.
//

import XCTest
@testable import Pokedex

class MockSuccessDetails: ServiceProtocol {
    func getPokemons(url: String, onSuccess: @escaping (String?, [FeedModel]) -> Void, onError: @escaping (Error) -> Void) {}
    
    func getDetails(id: Int, onSuccess: @escaping (DetailModel) -> Void, onError: @escaping (Error) -> Void) {
        let detailModel: DetailModel = DetailModel(name: "Pikachu", weight: 60.0, types: "Electric", stats: [], image: "", height: 4.0)
        onSuccess(detailModel)
    }
}

class MockFailureDetails: ServiceProtocol {
    func getPokemons(url: String, onSuccess: @escaping (String?, [FeedModel]) -> Void, onError: @escaping (Error) -> Void) {}
    
    func getDetails(id: Int, onSuccess: @escaping (DetailModel) -> Void, onError: @escaping (Error) -> Void) {
        onError(NSError(domain: "Erro ao carregar Detalhes", code: -1))
    }
}

final class DetailsViewModelTests: XCTestCase {

    //MARK: SUCCESS TESTS
    func testWhenSuccess() {
        let service = MockSuccessDetails()
        let sut = DetailsViewModel(id: 1, service: service)
                
        sut.state.bind { state in
            switch state {
            case .loading:
                XCTFail("Deveria falhar, mas o estado deu Loading")
            
            case .loaded(let detailModel):
                XCTAssertEqual(detailModel.name, "Pikachu")
                XCTAssertEqual(detailModel.weight, 60.0)
                XCTAssertEqual(detailModel.types, "Electric")
                XCTAssertEqual(detailModel.height, 4.0)
                
            case .error:
                XCTFail("Deveria falhar, mas o estado deu Error")
            }
        }
        
        sut.loadDataDetails()
    }
    
    //MARK: FAILURE TESTS
    func testWhenFailure() {
        let service = MockFailureDetails()
        let sut = DetailsViewModel(id: 25, service: service)
                                
        sut.state.bind { state in
            switch state {
            case .loading:
                XCTFail("Deveria falhar, mas o estado deu Loading")
            
            case .loaded(_):
                XCTFail("Deveria falhar, mas o estado deu Loaded")
            
            case .error:
                XCTAssertTrue(true)
            }
        }
        
        sut.loadDataDetails()
    }
}
