//
//  FeedViewModel.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import Foundation

enum FeedViewControllerStates {
    case loading
    case loaded
    case error
}

class FeedViewModel {
    var state: Bindable<FeedViewControllerStates> = Bindable(value: .loading)
    var newLabel: String = ""
    
    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.newLabel = "CARREGADO!"
            self.state.value = .loaded
        }
    }
}
