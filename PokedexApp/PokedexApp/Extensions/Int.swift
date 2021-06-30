//
//  Int.swift
//  PokedexApp
//
//  Created by Phong Le on 29/06/2021.
//

import UIKit

extension Int {
    func addDotLastNumber() -> String {
        return self < 10 ? "0.\(self)" : "\(self / 10).\(self % 10)"
    }
}
