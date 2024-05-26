//
//  DetailsViewController.swift
//  Pokedex
//
//  Created by Diggo Silva on 26/05/24.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let detailsView = DetailsView()
    
    override func loadView() {
        super.loadView()
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
    }
    
    private func setNavBar() {
        view.backgroundColor = .systemYellow
        title = "DETALHES"
    }
}
