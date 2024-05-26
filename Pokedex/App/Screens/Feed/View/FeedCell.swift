//
//  FeedCell.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import UIKit
import SDWebImage

class FeedCell: UICollectionViewCell {
    static let identifier = "FeedCell"
    
    lazy var pokedexImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
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
        fadeInFadeOut(alpha: 0)
        guard let url = URL(string: pokemon.imageUrl) else { return }
        
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.pokedexImage.image = image
                    if let averageColor = image.averageColor {
                        self.backgroundColor = averageColor
                    }
                }
            }
        }
        nameLabel.text = pokemon.name.capitalized
        self.layer.cornerRadius = 10
        fadeInFadeOut(alpha: 1)
    }
    
    private func fadeInFadeOut(alpha: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.pokedexImage.alpha = alpha
            self.nameLabel.alpha = alpha
        }
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
