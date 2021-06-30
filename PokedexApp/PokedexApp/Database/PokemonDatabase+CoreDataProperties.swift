//
//  PokemonDatabase+CoreDataProperties.swift
//  PokedexApp
//
//  Created by Phong Le on 30/06/2021.
//
//

import Foundation
import CoreData

extension PokemonDatabase {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonDatabase> {
        return NSFetchRequest<PokemonDatabase>(entityName: "PokemonDatabase")
    }

    @NSManaged public var sprite: String?
    @NSManaged public var name: String?
    @NSManaged public var id: Int32
    @NSManaged public var weight: Int32
    @NSManaged public var height: Int32
    @NSManaged public var backgroundColor: String?
    @NSManaged public var url: String?
}

extension PokemonDatabase : Identifiable {}
