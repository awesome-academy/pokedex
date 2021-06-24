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
    
    private let idPokemon: UILabel = {
        let idPokemon = UILabel()
        idPokemon.translatesAutoresizingMaskIntoConstraints = false
        return idPokemon
    }()
    
    // MARK: - Setup init
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 20
        
        contentView.addSubview(imagePokemon)
        contentView.addSubview(namePokemon)
        contentView.addSubview(idPokemon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            imagePokemon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imagePokemon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imagePokemon.heightAnchor.constraint(equalToConstant: 125),
            imagePokemon.widthAnchor.constraint(equalToConstant: 125)
        ])
        
        NSLayoutConstraint.activate([
            idPokemon.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            idPokemon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
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
    
    func configure(pokemon: Pokemon) {
        // configure name & id pokemon
        namePokemon.font = App.Font.pixel16
        namePokemon.text = pokemon.name
        namePokemon.textColor = App.Color.fontText
        
        idPokemon.font = App.Font.pixel16
        idPokemon.text = "#\(pokemon.id)"
        idPokemon.textColor = App.Color.fontText
        
        //background color
        contentView.backgroundColor = pokemon.type.backgroundColor
        
        //configure url image pokemon
        let keyCache = NSNumber(value: pokemon.id)
        
        if let cachedImage = App.Cache.cacheImage.object(forKey: keyCache) {
            imagePokemon.image = cachedImage
            return
        }
        
        DispatchQueue.global(qos: .utility).async {
            guard let url = URL(string: pokemon.urlImage) else { return }
            
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async { [weak self] in
                    guard let image = UIImage(data: data) else { return }
                    self?.imagePokemon.image = image
                    App.Cache.cacheImage.setObject(image, forKey: keyCache)
                }
            }
        }
    }
}
