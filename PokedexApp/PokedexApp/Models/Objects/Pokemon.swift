//
//  Pokemon.swift
//  PokedexApp
//
//  Created by Phong Le on 25/06/2021.
//

import UIKit

enum PokemonType: String, Codable {
    case normal = "normal", fire = "fire", water = "water", grass = "grass",
         electric = "electric", ice = "ice", fighting = "fighting", poison = "poison",
         ground = "ground", flying = "flying", psychic = "psychic", bug = "bug",
         rock = "rock", ghost = "ghost", dragon = "dragon", dark = "dark", steel = "steel", fairy = "fairy"
    
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
    
    static var randomColor: UIColor {
        let colors = [PokemonType.normal, .fire, .water, .grass, .electric,
                      .ice, .fighting, .poison, .ground, .flying, .psychic, .bug, .rock,
                      .ghost, .dragon, .dark, .steel, .fairy]
        
        let index = Int.random(in: 0...17)
        return colors[index].backgroundColor
    }
}

// list url pokemon
struct PokemonResults: Decodable {
    let results: [PokemonURL]
}

struct PokemonURL: Decodable {
    let name: String
    let url: String
}

// pokemon detail
struct Pokemon: Decodable {
    let abilities: [PokemonAbility]?
    let forms: [PokemonForms]?
    let height: Int?
    let id: Int?
    let sprites: PokemonSprites?
    let types: [PokemonTypeURL]?
    let weight: Int?
    let stats: [Stat]?
}

struct PokemonAbility: Decodable {
    let ability: Ability
}

struct Ability: Decodable {
    let name: String
}

struct PokemonForms: Decodable {
    let name: String
}

struct PokemonSprites: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonTypeURL: Decodable {
    let type: Type
}

struct Type: Decodable {
    let name: PokemonType
}

struct Stat: Decodable {
    let baseStat: Int
    let statName: StatName
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case statName = "stat"
    }
}

struct StatName: Decodable {
    let name: String
}
