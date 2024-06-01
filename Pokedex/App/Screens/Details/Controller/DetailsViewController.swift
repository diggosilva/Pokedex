//
//  DetailsViewController.swift
//  Pokedex
//
//  Created by Diggo Silva on 26/05/24.
//

import UIKit

class DetailsViewController: UIViewController {
    
    let detailsView = DetailsView()
    private let viewModel: DetailsViewModel
    
    init(id: Int) {
        self.viewModel = DetailsViewModel(id: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleStates()
        viewModel.loadDataDetails()    
    }
    
    private func handleStates() {
        viewModel.state.bind { states in
            switch states {
            case .loading:
                return self.showLoadingState()
            case .loaded(let detailModel):
                return self.showLoadedState(detailModel: detailModel)
            case .error:
                return self.showErrorState()
            }
        }
    }
    
    private func showLoadingState() {
        detailsView.removeFromSuperview()
    }
    
    private func showLoadedState(detailModel: DetailModel) {
        detailsView.configure(detailsModel: detailModel)
    }
    
    private func showErrorState() {
        let alert = UIAlertController(title: "Opa, Ocorreu um erro!", message: "Tentar novamente?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Sim", style: .default) { action in
            self.viewModel.loadDataDetails()
        }
        let nok = UIAlertAction(title: "Não", style: .cancel) { action in
            
        }
        alert.addAction(ok)
        alert.addAction(nok)
        present(alert, animated: true)
    }
}
