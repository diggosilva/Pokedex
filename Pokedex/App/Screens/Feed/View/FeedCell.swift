//
//  FeedCell.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import UIKit

class FeedCell: UICollectionViewCell {
    static let identifier = "FeedCell"
    
    lazy var pokedexImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person.fill")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
        self.backgroundColor = .systemPink.withAlphaComponent(0.2)
        self.layer.cornerRadius = 10
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy () {
        addSubview(pokedexImage)
        addSubview(nameLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            pokedexImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            pokedexImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            pokedexImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            pokedexImage.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            nameLabel.leadingAnchor.constraint(equalTo: pokedexImage.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: pokedexImage.trailingAnchor),
        ])
    }
}
