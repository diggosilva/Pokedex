//
//  FeedViewController.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import UIKit

class FeedViewController: UIViewController {
    
    private let feedView = FeedView()
    private let viewModel: FeedViewModelProtocol = FeedViewModel()
    
    override func loadView() {
        super.loadView()
        view = feedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegatesAndDataSource()
        handleStates()
        viewModel.loadDataPokemon()
    }
    
    private func setNavBar() {
        view.backgroundColor = .systemBackground
        title = "Pokedex"
    }
    
    private func setDelegatesAndDataSource() {
        feedView.collectionView.delegate = self
        feedView.collectionView.dataSource = self
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
        feedView.removeFromSuperview()
    }
    
    private func showLoadedState() {
        feedView.collectionView.reloadData()
        feedView.spinner.stopAnimating()
    }
    
    private func showErrorState() {
        
    }
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else { return UICollectionViewCell() }
        cell.configure(pokemon: viewModel.cellForItemAt(indexPath: indexPath))
        return cell
    }
}
