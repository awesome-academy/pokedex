//
//  SearchBarView.swift
//  PokedexApp
//
//  Created by Phong Le on 25/06/2021.
//

import UIKit

class SearchBarView: UIView {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = App.Color.backgroundSearchBar
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = "Pokemon name you want to find?"
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        configureSearchBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
    
    func configureSearchBar() {
        addSubview(searchBar)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
