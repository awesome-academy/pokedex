//
//  APIService.swift
//  PokedexApp
//
//  Created by Phong Le on 28/06/2021.
//

import UIKit

enum TypeURL {
    case type(String)
    case all
    
    var urlString: String {
        switch self {
        case .all:
            return App.API.urlAllPokemons + "?offset=\(APIService.offset)"
        case .type(let id):
            return App.API.urlTypePokemons + "\(id)"
        }
    }
}

struct APIService {
    static let shared = APIService()
    static var offset = 0
    
    private init() {}
    
    func fetchPokemonURL(completion: @escaping (Result<[PokemonURL]?, Error>) -> Void) {
        let urlString = TypeURL.all.urlString
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                guard let data = data else { return }
                let pokemonResults = try JSONDecoder().decode(PokemonResults.self, from: data)
                completion(.success(pokemonResults.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPokemonFromURL(url: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                guard let data = data else { return }
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                completion(.success(pokemon))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPokemonTypeURL(type: String, completion: @escaping (Result<[PokemonsTypeURL]?, Error>) -> Void) {
        let urlString = TypeURL.type(type).urlString
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                guard let data = data else { return }
                let pokemonResults = try JSONDecoder().decode(PokemonResultsType.self, from: data)
                completion(.success(pokemonResults.pokemon))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
