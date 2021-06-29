//
//  String.swift
//  PokedexApp
//
//  Created by Phong Le on 28/06/2021.
//

import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
