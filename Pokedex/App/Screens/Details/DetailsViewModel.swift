//
//  DetailsViewModel.swift
//  Pokedex
//
//  Created by Diggo Silva on 27/05/24.
//

import Foundation
import Combine

enum DetailsViewControllerStates {
    case loading
    case loaded(DetailModel)
    case error
}

protocol DetailsViewModelProtocol: StatefulViewModel where State == DetailsViewControllerStates {
    func loadDataDetails()
}

class DetailsViewModel {
    private var service: ServiceProtocol
    
    @Published private var state: DetailsViewControllerStates = .loading
    
    var statePublisher: AnyPublisher<DetailsViewControllerStates, Never> {
        $state.eraseToAnyPublisher()
    }
    
    let id: Int
    
    init(id: Int, service: ServiceProtocol = Service()) {
        self.id = id
        self.service = service
    }
    
    func loadDataDetails() {
        self.state = .loading
        
        Task { @MainActor in
            do {
                let details = try await service.getDetails(id: id)
                self.state = .loaded(details)
            } catch {
                print("DEBUG: Erro ao buscar detalhes do pokemon: \(error.localizedDescription)")
                self.state = .error
            }
        }
    }
}
