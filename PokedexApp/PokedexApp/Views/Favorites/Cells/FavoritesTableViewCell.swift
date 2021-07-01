//
//  FavoritesTableViewCell.swift
//  PokedexApp
//
//  Created by Phong Le on 30/06/2021.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    static let identifier = "FavoritesTableViewCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private let stackInfoNameOrWeight: UIStackView = {
        let stackInfoNameOrWeight = UIStackView()
        stackInfoNameOrWeight.translatesAutoresizingMaskIntoConstraints = false
        stackInfoNameOrWeight.axis = .vertical
        stackInfoNameOrWeight.spacing = 10
        stackInfoNameOrWeight.alignment = .leading
        return stackInfoNameOrWeight
    }()
    
    private let imagePokemon: UIImageView = {
        let imagePokemon = UIImageView()
        imagePokemon.translatesAutoresizingMaskIntoConstraints = false
        return imagePokemon
    }()
    
    private let namePokemon: UILabel = {
        let namePokemon = UILabel()
        namePokemon.font = App.Font.pixel18
        namePokemon.textColor = App.Color.fontText
        namePokemon.translatesAutoresizingMaskIntoConstraints = false
        return namePokemon
    }()
    
    private let weightAndHeight: UILabel = {
        let weightAndHeight = UILabel()
        weightAndHeight.font = App.Font.pixel14
        weightAndHeight.textColor = App.Color.fontText
        weightAndHeight.translatesAutoresizingMaskIntoConstraints = false
        return weightAndHeight
    }()
    
    private let idPokemon: UILabel = {
        let idPokemon = UILabel()
        idPokemon.font = App.Font.pixel16
        idPokemon.textColor = App.Color.fontText
        idPokemon.translatesAutoresizingMaskIntoConstraints = false
        idPokemon.textAlignment = .right
        return idPokemon
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 20
        contentView.addSubview(stackView)
        contentView.addSubview(idPokemon)
        
        stackView.addArrangedSubview(imagePokemon)
        stackInfoNameOrWeight.addArrangedSubview(namePokemon)
        stackInfoNameOrWeight.addArrangedSubview(weightAndHeight)
        stackView.addSubview(stackInfoNameOrWeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        let containerImage = UIView()
        containerImage.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(containerImage)
        
        NSLayoutConstraint.activate([
            containerImage.topAnchor.constraint(equalTo: stackView.topAnchor),
            containerImage.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            containerImage.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            containerImage.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            containerImage.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.3)
        ])
        
        containerImage.addSubview(imagePokemon)
        NSLayoutConstraint.activate([
            imagePokemon.centerYAnchor.constraint(equalTo: containerImage.centerYAnchor),
            imagePokemon.centerXAnchor.constraint(equalTo: containerImage.centerXAnchor),
            imagePokemon.widthAnchor.constraint(equalTo: containerImage.widthAnchor, multiplier: 1),
            imagePokemon.heightAnchor.constraint(equalTo: containerImage.heightAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            stackInfoNameOrWeight.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            stackInfoNameOrWeight.leadingAnchor.constraint(equalTo: containerImage.trailingAnchor),
        ])

        NSLayoutConstraint.activate([
            idPokemon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            idPokemon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            idPokemon.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        idPokemon.text = nil
        namePokemon.text = nil
        imagePokemon.image = nil
        weightAndHeight.text = nil
    }
    
    private func loadImageFromUrl(url: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            do {
                guard let url = URL(string: url) else { return }
                let data = try Data(contentsOf: url)
                completion(UIImage(data: data))
            } catch {
                print("load image failed: \(error.localizedDescription)")
            }
        }
    }
    
    func configure(pokemon: PokemonDatabase) {
        guard
            let name = pokemon.name,
            let sprite = pokemon.sprite,
            let color = pokemon.backgroundColor
        else { return }
        let weight = Int(pokemon.weight).addDotLastNumber()
        let height = Int(pokemon.height).addDotLastNumber()
        
        
        namePokemon.text = name.capitalizingFirstLetter()
        weightAndHeight.text = "\(height) m / \(weight) kg"
        idPokemon.text = "#\(pokemon.id)"
        contentView.backgroundColor = PokemonType(rawValue: color)?.backgroundColor
        
        if let cachedImage = App.Cache.cacheImage.object(forKey: NSNumber(value: pokemon.id)) {
            imagePokemon.image = cachedImage
            return
        }
        
        loadImageFromUrl(url: sprite) { [weak self] (image) in
            guard
                let image = image,
                let self = self
            else { return }
            
            DispatchQueue.main.async {
                self.imagePokemon.image = image
                App.Cache.cacheImage.setObject(image, forKey: NSNumber(value: pokemon.id))
            }
        }
    }
}
