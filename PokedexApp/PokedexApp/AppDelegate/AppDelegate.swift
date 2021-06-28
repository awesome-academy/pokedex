//
//  AppDelegate.swift
//  PokedexApp
//
//  Created by Phong Le on 24/06/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   
        //configure font UIBarButtonItem
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: App.Font.pixel18, .foregroundColor: App.Color.fontText], for: .normal)
        
        //configure font & color UITabbar
        UITabBarItem.appearance().setTitleTextAttributes([.font: App.Font.pixel12], for: .normal)
        UITabBar.appearance().tintColor = App.Color.backgroundColorHeader
        
        //configure font & color UINavigationBar
        let attributesNav = [NSAttributedString.Key.font: App.Font.pixel20,
                             NSAttributedString.Key.foregroundColor: App.Color.fontText]
        UINavigationBar.appearance().barTintColor = App.Color.backgroundColorHeader
        UINavigationBar.appearance().titleTextAttributes = attributesNav
        UINavigationBar.appearance().isTranslucent = false
        
        //configure font UITextField
        let attributesSearchBar = [NSAttributedString.Key.font: App.Font.pixel12]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributesSearchBar
        
        //configure UIBarButtonItem
        let attributesBarButton = [NSAttributedString.Key.font: App.Font.pixel18,
                             NSAttributedString.Key.foregroundColor: App.Color.fontText]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(attributesBarButton, for: .normal)
        
        return true
    }
}
