//
//  FavoritesViewController.swift
//  PokedexApp
//
//  Created by Phong Le on 24/06/2021.
//

import UIKit

class FavoritesViewController: UIViewController {
    private var dataFavorites = [Any]()
    private let spinner = UIActivityIndicatorView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: FavoritesTableViewCell.identifier)
        tableView.backgroundColor = App.Color.backgroundColor
        tableView.separatorInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Pokedex"
        navigationController?.navigationBar.barTintColor = App.Color.backgroundColorHeader
        reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        navigationItem.title = "Pokedex"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        spinner.frame = view.bounds
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureSpinner() {
        view.addSubview(spinner)
        spinner.color = .white
        spinner.startAnimating()
    }
    
    private func getPokemon(url: String) {
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
    
    private func reloadData() {
        configureSpinner()
        guard let data = DatabaseManager.shared.getPokemons() else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.dataFavorites = data
            self.tableView.reloadData()
            self.spinner.stopAnimating()
        }
    }
    private func notificationDelete(pokemon: PokemonDatabase, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Notification",
                                      message: "Are you sure to remove this pokemon from the list?",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { [weak self] _ in
            guard let self = self else { return }
            DatabaseManager.shared.deletePokemon(pokemon: pokemon)
            self.dataFavorites.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let pokemon = dataFavorites[indexPath.row] as? PokemonDatabase,
           let url = pokemon.url {
            getPokemon(url: url)
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as? FavoritesTableViewCell {
            guard let pokemon = dataFavorites[indexPath.row] as? PokemonDatabase else {
                fatalError()
            }
            
            cell.configure(pokemon: pokemon)
            cell.backgroundColor = App.Color.backgroundColor
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 20
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "") { [weak self] (_, _, completion) in
            guard
                let self = self,
                let pokemon = (self.dataFavorites[indexPath.row]) as? PokemonDatabase
            else { return }
            
            self.notificationDelete(pokemon: pokemon, indexPath: indexPath)
            completion(true)
        }
        
        deleteAction.image = UIGraphicsImageRenderer(size: CGSize(width: 70, height: 70)).image { _ in
            guard let image = UIImage(named: "trash") else { return }
            image.draw(in: CGRect(x: 0, y: 0, width: 70, height: 70))
        }
        deleteAction.backgroundColor = App.Color.backgroundColor
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
