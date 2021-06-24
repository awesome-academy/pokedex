//
//  SearchBarView.swift
//  PokedexApp
//
//  Created by Phong Le on 25/06/2021.
//

import UIKit

class SearchBarView: UIView {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = App.Color.backgroundSearchBar
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = "Enter name or id pokemon"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.configureSearchBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.searchBar.frame = self.bounds
    }
    
    func configureSearchBar() {
        self.addSubview(self.searchBar)
    }
}
