//
//  FeedViewController.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import UIKit
import Combine

class FeedViewController: UIViewController {
    
    private let feedView = FeedView()
    private let viewModel: any FeedViewModelProtocol = FeedViewModel()
    private var cancellables = Set<AnyCancellable>()
    
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
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setDelegatesAndDataSource() {
        feedView.collectionView.delegate = self
        feedView.collectionView.dataSource = self
        feedView.searchBar.delegate = self
    }
    
    private func handleStates() {
        viewModel.statePublisher.receive(on: RunLoop.main).sink { [ weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.showLoadingState()
            case .loaded:
                self.showLoadedState()
            case .error:
                self.showErrorState()
            }
        }.store(in: &cancellables)
    }
    
    private func showLoadingState() {
        feedView.setLoadingState()
    }
    
    private func showLoadedState() {
        feedView.setLoadedState()
        feedView.collectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = viewModel.cellForItemAt(indexPath: indexPath)
        let pokemonCell = collectionView.cellForItem(at: indexPath) as! FeedCell
        let detailsVC = DetailsViewController(id: pokemon.getId)
        detailsVC.detailsView.pokemonImage.image = pokemonCell._Image
        detailsVC.detailsView.backgroundColor = pokemonCell._BackgroundColor
        detailsVC.detailsView.typeLabel.backgroundColor = pokemonCell._BackgroundColor?.withAlphaComponent(0.8)
        navigationController?.pushViewController(detailsVC, animated: true)
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
