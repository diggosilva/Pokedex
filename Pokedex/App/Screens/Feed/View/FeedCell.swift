//
//  FeedCell.swift
//  Pokedex
//
//  Created by Diggo Silva on 24/05/24.
//

import UIKit
import SDWebImage
import Hero

class FeedCell: UICollectionViewCell {
    static let identifier = "FeedCell"
    
    lazy var pokemonImage: UIImageView = {
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
    
    var _Image: UIImage?
    var _BackgroundColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(pokemon: FeedModel) {
        fadeInFadeOut(alpha: 0)
        configureHeroId(pokemon: pokemon)
        configureImageAndName(pokemon: pokemon)
        fadeInFadeOut(alpha: 1)
        
 
    }
    
    func configureHeroId(pokemon: FeedModel) {
        nameLabel.hero.id = pokemon.url
        pokemonImage.hero.id = pokemon.name
        hero.id = "\(pokemon.getId)"
    }
    
    func configureImageAndName(pokemon: FeedModel) {
        guard let url = URL(string: pokemon.imageUrl) else { return }
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self._Image = image
                    self.pokemonImage.image = image
                    if let averageColor = image.averageColor {
                        self.backgroundColor = averageColor.withAlphaComponent(1)
                        self._BackgroundColor = averageColor.withAlphaComponent(1)
                        
                        self.layer.shadowColor = UIColor.black.cgColor
                        self.layer.shadowOffset = CGSize(width: 5, height: 5)
                        self.layer.shadowOpacity = 0.4
                        self.layer.shadowRadius = 3.0
                    }
                }
            }
        }
        nameLabel.text = pokemon.name.capitalized
        self.layer.cornerRadius = 10
    }
    
    private func fadeInFadeOut(alpha: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.pokemonImage.alpha = alpha
            self.nameLabel.alpha = alpha
            self.alpha = alpha
        }
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy () {
        addSubviews([pokemonImage, nameLabel])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            pokemonImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            pokemonImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            pokemonImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            pokemonImage.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            nameLabel.leadingAnchor.constraint(equalTo: pokemonImage.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: pokemonImage.trailingAnchor),
        ])
    }
}
