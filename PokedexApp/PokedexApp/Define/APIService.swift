//
//  APIService.swift
//  PokedexApp
//
//  Created by Phong Le on 28/06/2021.
//

import UIKit

struct APIService {
    static let shared = APIService()
    static var offset = 0
    
    private init() {}
    
    func fetchPokemonURL(completion: @escaping (Result<[PokemonURL]?, Error>) -> Void) {
        let urlString = App.API.urlAllPokemons + "?offset=\(APIService.offset)"
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
}
