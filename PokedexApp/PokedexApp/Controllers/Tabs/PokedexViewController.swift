//
//  PokedexViewController.swift
//  PokedexApp
//
//  Created by Phong Le on 24/06/2021.
//

import UIKit

class PokedexViewController: UIViewController {
    
    // MARK: - Setup properties
    
    let collectionView: UICollectionView = {
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
    
    var pokemons = [PokemonURL]()
    var pokemonsType = [PokemonsTypeURL]()
    var nameType = ""
    var checkNav = false
    private var spinner = UIActivityIndicatorView()
    private var checkLoad = false
    private let layout = UICollectionViewFlowLayout()
    private let uiViewSearchBar = SearchBarView()
    
    // MARK: - Setup init
    
    init(nameType: String) {
        super.init(nibName: nil, bundle: nil)
        self.nameType = nameType
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureCollectionView()
        tapScreenDismissKeyboard()
        choiceRunAPI()
        configureSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Pokedex"
        checkNav = true
        
        if let nav = navigationController {
            nav.navigationBar.barTintColor = App.Color.backgroundColorHeader
            nav.navigationBar.tintColor = App.Color.fontText
        }
        
        if !nameType.isEmpty {
            pokemons = []
            collectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.title = ""
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupLayoutSearchBar(height: 40)
        setupLayoutCollectionView()
        
        view.addSubview(textNotification)
        textNotification.frame = view.bounds
    }
    
    // MARK: - Setup method
    
    private func configure() {
        view.backgroundColor = App.Color.backgroundColor
        navigationItem.title = "Pokedex"
        pokemons = []
        pokemonsType = []
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
    
    private func setupLayoutSearchBar(height: CGFloat) {
        view.addSubview(uiViewSearchBar)
        
        NSLayoutConstraint.activate([
            uiViewSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            uiViewSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            uiViewSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            uiViewSearchBar.heightAnchor.constraint(equalToConstant: height)
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
    
    @objc func didTapDissmissKeyboard() {
        view.endEditing(true)
    }
    
    func getPokemonsFromAPI() {
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
                print("fetch pokemon url failed: \(error.localizedDescription)")
            }
        }
    }
    
    func getPokemonsTypeFromAPI() {
        layout.footerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 100)
        spinner.startAnimating()
        textNotification.text = ""
        setupLayoutSearchBar(height: 0)

        APIService.shared.fetchPokemonTypeURL(type: nameType) { [weak self] (result) in
            switch result {
            case .success(let pokemons):
                guard let pokemons = pokemons, let self = self else { return }
                
                self.pokemonsType = pokemons
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.layout.footerReferenceSize = CGSize(width: 0, height: 0)
                    self.spinner.stopAnimating()
                    self.checkLoad.toggle()
                }
                
            case .failure(let error):
                print("fetch pokemon type url failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func choiceRunAPI() {
        if pokemonsType.isEmpty {
            getPokemonsFromAPI()
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
        
        let pokemonsFilter = pokemons.filter { $0.name.contains(queryName) }
        pokemons = []
        
        if !pokemonsFilter.isEmpty {
            pokemons = pokemonsFilter
            resetCollectionView()
            return
        }
        
        resetCollectionView()
        textNotification.text = "Pokemon you're looking for doesn't exist"
    }
    
    func getPokemon(url: String) {        
        APIService.shared.fetchPokemonFromURL(url: url) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let pokemonResponse):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let pokemonDetailViewController = DetailsViewController(pokemon: pokemonResponse)
                    let navController = UINavigationController(rootViewController: pokemonDetailViewController)
                    
                    navController.modalPresentationStyle = .fullScreen
                    self.transitionVc(vc: navController, duration: 0.32, type: .fromRight)
                }
            case .failure(let error):
                print("get pokemon failed: \(error)")
            }
        }
    }
    
    static func instance(nameType: String) -> PokedexViewController {
        let pokedexVC = PokedexViewController(nameType: nameType)
        pokedexVC.getPokemonsTypeFromAPI()
        return pokedexVC
    }
}

// MARK: - Extensions
extension PokedexViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        if checkNav {
            let pokemonURL = pokemonsType.isEmpty ?
                pokemons[indexPath.row].url :
                pokemonsType[indexPath.row].pokemon.url
            
            getPokemon(url: pokemonURL)
            checkNav = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentSizeCollectionView = collectionView.contentSize.height
        let frameScrollView = scrollView.frame.size.height
        
        if checkLoad && position > (contentSizeCollectionView - frameScrollView + 150) {
            choiceRunAPI()
            layout.footerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 100)
            spinner.startAnimating()
            textNotification.text = ""
            checkLoad.toggle()
        }
    }
}

extension PokedexViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonsType.isEmpty ? pokemons.count : pokemonsType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokedexCollectionViewCell.identifier,
                                                         for: indexPath) as? PokedexCollectionViewCell {
            if !pokemonsType.isEmpty {
                let pokemonType = pokemonsType[indexPath.row]
                cell.configure(pokemon: nil, pokemonType: pokemonType, nameType: nameType)
                
                return cell
            }
            else {
                let pokemon = pokemons[indexPath.row]
                cell.configure(pokemon: pokemon, pokemonType: nil, nameType: nil)
                
                return cell
            }
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
        if searchText.isEmpty {
            APIService.offset = 0
            pokemons = []
            choiceRunAPI()
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
