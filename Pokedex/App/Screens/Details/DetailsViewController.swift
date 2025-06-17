//
//  DetailsViewController.swift
//  Pokedex
//
//  Created by Diggo Silva on 26/05/24.
//

import UIKit
import Combine

class DetailsViewController: UIViewController {
    
    let detailsView = DetailsView()
    let viewModel: DetailsViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(id: Int) {
        self.viewModel = DetailsViewModel(id: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
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
        viewModel.statePublisher.receive(on: RunLoop.main).sink { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                return self.showLoadingState()
            case .loaded(let detailModel):
                return self.showLoadedState(detailModel: detailModel)
            case .error:
                return self.showErrorState()
            }
        }.store(in: &cancellables)
    }
    
    private func showLoadingState() {}
    
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
