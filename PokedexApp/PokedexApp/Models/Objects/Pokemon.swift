//
//  Pokemon.swift
//  PokedexApp
//
//  Created by Phong Le on 25/06/2021.
//

import UIKit

enum PokemonType {
    case normal, fire, water, grass, electric, ice, fighting, poison, ground,
         flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy
    
    var backgroundColor: UIColor {
        switch self {
        case .normal: return App.Color.normal
        case .fire: return App.Color.fire
        case .water: return App.Color.water
        case .grass: return App.Color.grass
        case .electric: return App.Color.electric
        case .ice: return App.Color.ice
        case .fighting: return App.Color.fighting
        case .poison: return App.Color.poison
        case .ground: return App.Color.ground
        case .flying: return App.Color.flying
        case .psychic: return App.Color.psychic
        case .bug: return App.Color.bug
        case .rock: return App.Color.rock
        case .ghost: return App.Color.ghost
        case .dragon: return App.Color.dragon
        case .dark: return App.Color.dark
        case .steel: return App.Color.steel
        case .fairy: return App.Color.fairy
        }
    }
}

struct Pokemon: Identifiable {
    let id: Int
    let name: String
    let urlImage: String
    let type: PokemonType
}
