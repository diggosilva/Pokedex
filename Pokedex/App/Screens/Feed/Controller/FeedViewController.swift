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
        feedView.searchBar.delegate = self
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
        let alert = UIAlertController(title: "Opa, ocorreu um erro!", message: "Tentar novamente?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Sim", style: .default) { action in
            self.viewModel.loadDataPokemon()
        }
        let nok = UIAlertAction(title: "Não", style: .cancel) { action in
            self.feedView.spinner.stopAnimating()
            self.feedView.errorLabel.isHidden = false
        }
        alert.addAction(ok)
        alert.addAction(nok)
        present(alert, animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.collectionView(forItemAt: indexPath)
    }
}

extension FeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBar(textDidChange: searchText)
        feedView.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
