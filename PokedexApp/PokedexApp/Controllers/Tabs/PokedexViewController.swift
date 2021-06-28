//
//  PokedexViewController.swift
//  PokedexApp
//
//  Created by Phong Le on 24/06/2021.
//

import UIKit

class PokedexViewController: UIViewController {
    
    // MARK: - Setup properties
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.register(PokedexCollectionViewCell.self,
                                forCellWithReuseIdentifier: PokedexCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .clear
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let uiViewSearchBar: UIView = {
        let uiViewSearchBar = SearchBarView()
        uiViewSearchBar.translatesAutoresizingMaskIntoConstraints = false
        return uiViewSearchBar
    }()
    
    private var pokemons = [Pokemon]()
    
    // MARK: - Setup init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureCollectionView()
        // dummy data
        configureDataPokemons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Pokedex"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    // MARK: - Setup layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupLayoutSearchBar()
        setupLayoutCollectionView()
    }
    
    // MARK: - Setup method
    
    private func configure() {
        view.backgroundColor = App.Color.backgroundColor
        navigationItem.title = "Pokedex"
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configureDataPokemons() {
        pokemons.append(contentsOf: dummyData)
    }
    
    func setupLayoutSearchBar() {
        view.addSubview(uiViewSearchBar)
        
        NSLayoutConstraint.activate([
            uiViewSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            uiViewSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            uiViewSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            uiViewSearchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupLayoutCollectionView() {
        view.addSubview(collectionView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.bounds.width / 2.4), height: (view.bounds.width / 2.4))
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        
        collectionView.collectionViewLayout = layout
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: uiViewSearchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Dummy data
let dummyData = [
    Pokemon(id: 1,
            name: "Bulbasaur",
            urlImage: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
            type: .grass),
    Pokemon(id: 2,
            name: "Ivysaur",
            urlImage: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png",
            type: .grass),
    Pokemon(id: 3,
            name: "Venusaur",
            urlImage: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png",
            type: .grass),
    Pokemon(id: 4,
            name: "Charmander",
            urlImage: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png",
            type: .fire),
    Pokemon(id: 5,
            name: "Charmeleon",
            urlImage: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/5.png",
            type: .fire),
    Pokemon(id: 7,
            name: "Squirtle",
            urlImage: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png",
            type: .water),
]

// MARK: - Extensions

extension PokedexViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let pokemonDetailViewController = DetailsViewController()
        navigationController?.pushViewController(pokemonDetailViewController, animated: true)
    }
}

extension PokedexViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokedexCollectionViewCell.identifier,
                                                         for: indexPath) as? PokedexCollectionViewCell {
            let pokemon = pokemons[indexPath.row]
            cell.configure(pokemon: pokemon)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}
