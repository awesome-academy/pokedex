//
//  PokedexCollectionViewCell.swift
//  PokedexApp
//
//  Created by Phong Le on 25/06/2021.
//

import UIKit

class PokedexCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Setup properties
    
    static let identifier = "PokedexCollectionViewCell"
    
    private let imagePokemon: UIImageView = {
        let imagePokemon = UIImageView()
        imagePokemon.translatesAutoresizingMaskIntoConstraints = false
        return imagePokemon
    }()
    
    private let namePokemon: UILabel = {
        let namePokemon = UILabel()
        namePokemon.translatesAutoresizingMaskIntoConstraints = false
        return namePokemon
    }()
    
    // MARK: - Setup init
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 20
        contentView.addSubview(imagePokemon)
        contentView.addSubview(namePokemon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let sizeImage = (75 / contentView.bounds.width)
        
        NSLayoutConstraint.activate([
            imagePokemon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imagePokemon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imagePokemon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: sizeImage),
            imagePokemon.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: sizeImage)
        ])
        
        NSLayoutConstraint.activate([
            namePokemon.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            namePokemon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Setup method
    
    func configure(pokemon: PokemonURL?, pokemonType: PokemonsTypeURL?, nameType: String?) {
        if let pokemon = pokemon {
            // configure name
            namePokemon.font = App.Font.pixel16
            namePokemon.text = pokemon.name.capitalizingFirstLetter()
            namePokemon.textColor = App.Color.fontText
            
            //background color
            let keyCache = NSString(string: pokemon.url)
            
            if let cachedBackgroundColor = App.Cache.cacheBackgroundColor.object(forKey: keyCache) {
                contentView.backgroundColor = cachedBackgroundColor
            } else {
                let backgroundColor = PokemonType.randomColor
                contentView.backgroundColor = backgroundColor
                App.Cache.cacheBackgroundColor.setObject(backgroundColor, forKey: keyCache)
            }
            
            imagePokemon.image = UIImage(named: "pokeball")
        }
        
        if let pokemonType = pokemonType, let nameType = nameType {
            // configure name
            namePokemon.font = App.Font.pixel16
            namePokemon.text = pokemonType.pokemon.name.capitalizingFirstLetter()
            namePokemon.textColor = App.Color.fontText
            
            //background color
            guard let pokemonTypeColor = PokemonType(rawValue: nameType) else { return }
            let backgroundColor = pokemonTypeColor.backgroundColor
            contentView.backgroundColor = backgroundColor
            
            imagePokemon.image = UIImage(named: "pokeball")
        }
    }
}
