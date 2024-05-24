//
//  FeedViewController.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import UIKit

class FeedViewController: UIViewController {
    
    let viewModel = FeedViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        handleStates()
        viewModel.loadData()
    }
    
    private func setNavBar() {
        view.backgroundColor = .systemBackground
        title = "Pokedex"
    }
    
    private func handleStates() {
        viewModel.state.bind { states in
            switch states {
            case .loading:
                return self.showLoadingState()
            case .loaded:
                return self.showLoadedState()
            case .error:
                return self.showErrorState()
            }
        }
    }
    
    private func showLoadingState() {
        
    }
    
    private func showLoadedState() {
 
    }
    
    private func showErrorState() {
        
    }
}
