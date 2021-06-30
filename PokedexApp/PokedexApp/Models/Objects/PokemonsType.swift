//
//  PokemonsType.swift
//  PokedexApp
//
//  Created by Phong Le on 30/06/2021.
//

import Foundation

struct PokemonResultsType: Decodable {
    let pokemon: [PokemonsTypeURL]
}

struct PokemonsTypeURL: Decodable {
    let pokemon: PokemonURL
}
