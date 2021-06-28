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
        
        collectionView.register(FooterPokedexReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterPokedexReusableView.identifier)
        
        collectionView.backgroundColor = .clear
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let textNotification: UILabel = {
        let textNotification = UILabel()
        textNotification.font = App.Font.pixel12
        textNotification.text = ""
        textNotification.textColor = App.Color.fontText
        textNotification.textAlignment = .center
        return textNotification
    }()
    
    private var pokemons = [PokemonURL]()
    private var spinner = UIActivityIndicatorView()
    private var checkLoad = false
    private let layout = UICollectionViewFlowLayout()
    private let uiViewSearchBar = SearchBarView()
    
    // MARK: - Setup init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureCollectionView()
        tapScreenDismissKeyboard()
        getPokemonsFromAPI()
        configureSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Pokedex"
        navigationController?.navigationBar.barTintColor = App.Color.backgroundColorHeader
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
        
        view.addSubview(textNotification)
        textNotification.frame = view.bounds

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
    
    private func tapScreenDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDissmissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func configureSearchBar() {
        uiViewSearchBar.searchBar.delegate = self
    }
    
    private func setupLayoutSearchBar() {
        view.addSubview(uiViewSearchBar)
        
        NSLayoutConstraint.activate([
            uiViewSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            uiViewSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            uiViewSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            uiViewSearchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupLayoutCollectionView() {
        view.addSubview(collectionView)

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
    
    @objc private func didTapDissmissKeyboard() {
        view.endEditing(true)
    }
    
    private func getPokemonsFromAPI() {
        layout.footerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 100)
        spinner.startAnimating()
        textNotification.text = ""
        
        APIService.shared.fetchPokemonURL { [weak self] (result) in
            switch result {
            case .success(let pokemons):
                guard let pokemons = pokemons, let self = self else { return }
                
                self.pokemons.append(contentsOf: pokemons)
                APIService.offset += 20
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.layout.footerReferenceSize = CGSize(width: 0, height: 0)
                    self.spinner.stopAnimating()
                    self.checkLoad.toggle()
                }
                
            case .failure(let error):
                print("fetch pokemon url failed: \(error)")
            }
        }
    }
    
    private func resetCollectionView() {
        collectionView.reloadData()
        layout.footerReferenceSize = CGSize(width: 0, height: 0)
        spinner.stopAnimating()
        checkLoad.toggle()
    }
    
    func getPokemonByName(queryName: String) {
        layout.footerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 100)
        spinner.startAnimating()
        textNotification.text = ""
        
        let pokemon = pokemons.filter { $0.name == queryName }
        pokemons = []
        
        if let pokemon = pokemon.first {
            pokemons.append(pokemon)
            resetCollectionView()
            return
        }
        
        resetCollectionView()
        textNotification.text = "Pokemon you're looking for doesn't exist"
    }
}

// MARK: - Extensions
extension PokedexViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let pokemonDetailViewController = DetailsViewController()
        navigationController?.pushViewController(pokemonDetailViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentSizeCollectionView = collectionView.contentSize.height
        let frameScrollView = scrollView.frame.size.height
        
        if checkLoad && position > (contentSizeCollectionView - frameScrollView + 150) {
            getPokemonsFromAPI()
            layout.footerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 100)
            spinner.startAnimating()
            textNotification.text = ""
            checkLoad.toggle()
        }
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: FooterPokedexReusableView.identifier,
                                                                     for: indexPath) as? FooterPokedexReusableView {
            footer.addSubview(spinner)
            spinner.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
            spinner.color = .white
            return footer
        }
        return UICollectionReusableView()
    }
}

extension PokedexViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty && (pokemons.count == 1 || pokemons.count == 0) {
            APIService.offset = 0
            pokemons = []
            getPokemonsFromAPI()
            view.endEditing(true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let queryName = searchBar.text else { return }
        APIService.offset = 0
        collectionView.reloadData()
        getPokemonByName(queryName: queryName)
        view.endEditing(true)
    }
}
