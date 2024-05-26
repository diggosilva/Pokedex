//
//  DetailsView.swift
//  Pokedex
//
//  Created by Diggo Silva on 26/05/24.
//

import UIKit

class DetailsView: UIView {
    lazy var fakePagePresentation: UIView = {
        let page = UIView()
        page.translatesAutoresizingMaskIntoConstraints = false
        page.backgroundColor = .white
        page.layer.cornerRadius = 30
        return page
    }()
    
    lazy var pokemonImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person.fill")
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .red
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.text = "Nome do Pokemon"
        return label
    }()
    
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.text = "Poison"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 17.5
        label.clipsToBounds = true
        return label
    }()
    
    lazy var statsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "Stats"
        return label
    }()
    
    //MARK: - Stack VERTICAL Labels
    lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.text = "Altura"
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var attackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.text = "Ataque"
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var defenseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.text = "Defesa"
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.text = "Peso"
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var vLabelsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [heightLabel, attackLabel, defenseLabel, weightLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    //MARK: - Stack VERTICAL VALUE Labels
    lazy var heightValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.text = "7"
        label.textColor = .black
        return label
    }()
    
    lazy var attackValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.text = "49"
        label.textColor = .black
        return label
    }()
    
    lazy var defenseValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.text = "54"
        label.textColor = .black
        return label
    }()
    
    lazy var weightValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.text = "69"
        label.textColor = .black
        return label
    }()
    
    lazy var vLabelsValueStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [heightValueLabel, attackValueLabel, defenseValueLabel, weightValueLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    //MARK: - Stack VERTICAL ProgressView
    lazy var heightProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemOrange
        progressView.progress = 0.1
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        progressView.contentMode = .scaleAspectFit
        return progressView
    }()
    
    lazy var attackProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemRed
        progressView.progress = 0.1
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        progressView.contentMode = .scaleAspectFit
        return progressView
    }()
    
    lazy var defenseProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemCyan
        progressView.progress = 0.1
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        progressView.contentMode = .scaleAspectFit
        return progressView
    }()
    
    lazy var weightProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemIndigo
        progressView.progress = 0.1
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        progressView.contentMode = .scaleAspectFit
        return progressView
    }()
    
    lazy var vProgressStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [heightProgressView, attackProgressView, defenseProgressView, weightProgressView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    //MARK: - Stack HORIZONTAL
    lazy var statsHStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [vLabelsStack, vLabelsValueStack, vProgressStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy () {
        addSubviews([fakePagePresentation, pokemonImage, nameLabel, typeLabel, statsLabel, statsHStack])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            fakePagePresentation.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 200),
            fakePagePresentation.leadingAnchor.constraint(equalTo: leadingAnchor),
            fakePagePresentation.trailingAnchor.constraint(equalTo: trailingAnchor),
            fakePagePresentation.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            pokemonImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            pokemonImage.topAnchor.constraint(equalTo: fakePagePresentation.topAnchor, constant: -150),
            pokemonImage.widthAnchor.constraint(equalToConstant: 200),
            pokemonImage.heightAnchor.constraint(equalTo: pokemonImage.widthAnchor),
            
            nameLabel.centerXAnchor.constraint(equalTo: pokemonImage.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: pokemonImage.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: fakePagePresentation.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: fakePagePresentation.trailingAnchor, constant: -10),
            
            typeLabel.centerXAnchor.constraint(equalTo: pokemonImage.centerXAnchor),
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            typeLabel.widthAnchor.constraint(equalToConstant: 100),
            typeLabel.heightAnchor.constraint(equalToConstant: 35),
            
            statsLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 30),
            statsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statsLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            statsHStack.centerXAnchor.constraint(equalTo: pokemonImage.centerXAnchor),
            statsHStack.topAnchor.constraint(equalTo: statsLabel.bottomAnchor, constant: 30),
            statsHStack.leadingAnchor.constraint(equalTo: fakePagePresentation.leadingAnchor, constant: 30),
            statsHStack.trailingAnchor.constraint(equalTo: fakePagePresentation.trailingAnchor, constant: -30),
        ])
    }
}
