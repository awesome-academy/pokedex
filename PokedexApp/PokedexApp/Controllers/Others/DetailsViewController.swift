//
//  DetailsViewController.swift
//  PokedexApp
//
//  Created by Phong Le on 24/06/2021.
//

import UIKit

class DetailsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        view.backgroundColor = App.Color.backgroundColor
        navigationItem.title = "Pokemon"
        navigationController?.navigationBar.tintColor = App.Color.fontText
    }
}
