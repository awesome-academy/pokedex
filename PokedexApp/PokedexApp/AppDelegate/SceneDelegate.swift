//
//  SceneDelegate.swift
//  PokedexApp
//
//  Created by Phong Le on 24/06/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let pokedexViewController = PokedexViewController(nameType: "")
        let pokedexNav = UINavigationController(rootViewController: pokedexViewController)
        
        let titlePokedex = UILabel()
        titlePokedex.font = App.Font.pixel14
        titlePokedex.text = "Pokedex"
        titlePokedex.textColor = App.Color.fontTextTitle
        
        pokedexViewController.tabBarItem = UITabBarItem(title: titlePokedex.text,
                                                        image: UIImage(systemName: "rectangle")?.resizeTabBarItem(),
                                                        selectedImage: UIImage(systemName: "rectangle.fill")?.resizeTabBarItem())
        
        let genresViewController = GenresViewController()
        let genresNav = UINavigationController(rootViewController: genresViewController)
        
        let titleGenres = UILabel()
        titleGenres.font = App.Font.pixel14
        titleGenres.text = "Genres"
        titleGenres.textColor = App.Color.fontTextTitle
        
        genresViewController.tabBarItem = UITabBarItem(title: titleGenres.text,
                                                       image: UIImage(systemName: "circle")?.resizeTabBarItem(),
                                                       selectedImage: UIImage(systemName: "circle.fill")?.resizeTabBarItem())
        
        let favoritesViewController = FavoritesViewController()
        let favoritesNav = UINavigationController(rootViewController: favoritesViewController)
        
        let titlefavorites = UILabel()
        titlefavorites.font = App.Font.pixel14
        titlefavorites.text = "Favorites"
        titlefavorites.textColor = App.Color.fontTextTitle
        
        favoritesViewController.tabBarItem = UITabBarItem(title: titlefavorites.text,
                                                        image: UIImage(systemName: "triangle")?.resizeTabBarItem(),
                                                        selectedImage: UIImage(systemName: "triangle.fill")?.resizeTabBarItem())
        
        // tabbar
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [pokedexNav, genresNav, favoritesNav]
        tabBarController.tabBar.barTintColor = App.Color.backgroundColor
        
        self.window = window
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = tabBarController
    }
}
