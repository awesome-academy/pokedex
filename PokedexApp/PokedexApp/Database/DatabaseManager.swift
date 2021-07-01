//
//  DatabaseManager.swift
//  PokedexApp
//
//  Created by Phong Le on 30/06/2021.
//

import UIKit
import CoreData

enum AlertDatabase {
    case successfullyAdded, addedFailure, addDuplicated
    
    var message: String {
        switch self {
        case .successfullyAdded:
            return "You have successfully added a pokemon"
        case .addedFailure:
            return "You have failed to add a pokemon"
        case .addDuplicated:
            return "Pokemon already in your favorites"
        }
    }
}

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let presistentContainer: NSPersistentContainer
    
    private init() {
        presistentContainer = NSPersistentContainer(name: "PokemonsDatabase")
        presistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                print("pokemon dataase failed: \(error.localizedDescription)")
            }
        }
    }
    
    func getPokemons() -> [PokemonDatabase]? {
        let context = presistentContainer.viewContext
        
        do {
            let request = PokemonDatabase.fetchRequest() as NSFetchRequest<PokemonDatabase>
            let pokemons = try context.fetch(request)
            return pokemons
        } catch {
            print("get pokemons in database failed: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func addPokemon(pokemon: Pokemon, completion: @escaping (String) -> Void) {
        guard
            let pokemonTypes = pokemon.types,
            let backgroundColor = pokemonTypes.first,
            let height = pokemon.height,
            let weight = pokemon.weight,
            let id = pokemon.id,
            let nameForms = pokemon.forms,
            let nameFirst = nameForms.first,
            let sprites = pokemon.sprites
        else { return }
    
        let context = presistentContainer.viewContext
        
        do {
            let request = PokemonDatabase.fetchRequest() as NSFetchRequest<PokemonDatabase>
            let pokemons = try context.fetch(request)
            
            if pokemons.contains(where: { $0.id == id }) {
                if pokemon.id == id {
                    completion(AlertDatabase.addDuplicated.message)
                    return
                }
            }
            
            let newPokemon = PokemonDatabase(context: presistentContainer.viewContext)
            newPokemon.backgroundColor = backgroundColor.type.name.rawValue
            newPokemon.height = Int32(height)
            newPokemon.weight = Int32(weight)
            newPokemon.id = Int32(id)
            newPokemon.name = nameFirst.name
            newPokemon.sprite = sprites.frontDefault
            newPokemon.url = "\(App.API.urlAllPokemons)\(id)"
            
            try context.save()
            completion(AlertDatabase.successfullyAdded.message)
            print("added pokemon!")
            
        } catch {
            print("add pokemon failed: \(error)")
            completion(AlertDatabase.addedFailure.message)
        }
    }
    func deletePokemon(pokemon: PokemonDatabase) {
        let context = presistentContainer.viewContext
        do {
            context.delete(pokemon)
            try context.save()
        } catch {
            print("delete pokemon failed: \(error.localizedDescription)")
        }
    }
}
