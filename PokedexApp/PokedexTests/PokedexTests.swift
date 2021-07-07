//
//  PokedexTests.swift
//  PokedexTests
//
//  Created by Phong Le on 06/07/2021.
//

import XCTest
@testable import Pokedex

class PokedexTests: XCTestCase {
    var sut: PokedexViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PokedexViewController(nameType: "")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testInitCoder() throws {
        sut = PokedexViewController(coder: NSCoder())
        XCTAssertNil(sut)
    }
    
    func testGetPokemonsFromAPI() throws {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        var pokemons: [PokemonURL]?
        
        do {
            let jsonData = try Data(contentsOf: url)
            let pokemonResults = try JSONDecoder().decode(PokemonResults.self, from: jsonData)
            
            pokemons = pokemonResults.results
        } catch {
            XCTAssertNil(error)
        }
        
        guard let pokemon = pokemons?.first else { return }
        XCTAssertEqual("bulbasaur", pokemon.name)
    }
    
    func testGetPokemonsTypeFromAP() throws {
        sut = PokedexViewController(nameType: "normal")
        sut.getPokemonsTypeFromAPI()
        XCTAssertNotNil(sut.pokemonsType)
    }
    
    func testGetPokemonByName() throws {
        sut.getPokemonByName(queryName: "bulbasaur")
        XCTAssertNotNil(sut.pokemons)
    }
    
    func testGetPokemon() throws {
        sut.getPokemon(url: "https://pokeapi.co/api/v2/pokemon/1")
        XCTAssertNotNil(sut)
    }
    
    func testInstance() throws {
        let vc = PokedexViewController.instance(nameType: "normal")
        XCTAssertNotNil(vc)
    }
}
