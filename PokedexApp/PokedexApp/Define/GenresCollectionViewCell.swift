//
//  GenresCollectionViewCell.swift
//  PokedexApp
//
//  Created by Phong Le on 30/06/2021.
//

import UIKit

class GenresCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenresCollectionViewCell"
    
    private let textType: UILabel = {
        let textLabel = UILabel()
        textLabel.font = App.Font.pixel18
        textLabel.textColor = App.Color.fontText
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textType)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textType.frame = contentView.bounds
    }
    
    func configure(type: String) {
        textType.text = type.capitalizingFirstLetter()
        guard let pokemonType = PokemonType(rawValue: type) else { return }
        contentView.backgroundColor = pokemonType.backgroundColor
    }
}
