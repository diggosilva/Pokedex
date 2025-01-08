//
//  DetailsViewModel.swift
//  Pokedex
//
//  Created by Diggo Silva on 27/05/24.
//

import Foundation

enum DetailsViewControllerStates {
    case loading
    case loaded(DetailModel)
    case error
}

class DetailsViewModel {
    private(set) var state: Bindable<DetailsViewControllerStates> = Bindable(value: .loading)
    private var service = Service()
    
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func loadDataDetails() {
        service.getDetails(id: id) { detailsModel in
            self.state.value = .loaded(detailsModel)
        } onError: { error in
            self.state.value = .error
        }
    }
}
