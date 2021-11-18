//
//  TabbarViewController.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 8/11/21.
//

import UIKit

class TabbarViewController: UITabBarController {
    
    lazy var homeNavVC: UINavigationController = {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        homeVC.navigationItem.largeTitleDisplayMode = .never
        homeVC.navigationItem.title = "Browse"
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        let nav = UINavigationController(rootViewController: homeVC)
        nav.navigationBar.tintColor = .white
        nav.navigationBar.barStyle = .black
        nav.navigationBar.isTranslucent = true
        return nav
    }()
    
    lazy var SearchNavVC: UINavigationController = {
        let searchVC = SearchViewController(nibName: "SearchViewController", bundle: nil)
        searchVC.navigationItem.largeTitleDisplayMode = .always
        searchVC.navigationItem.title = "Search"
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        let nav = UINavigationController(rootViewController: searchVC)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.tintColor = .white
        nav.navigationBar.barStyle = .black
        return nav
    }()
    
    lazy var LibraryNavVC: UINavigationController = {
        let libraryVC = LibraryViewController(nibName: "LibraryViewController", bundle: nil)
        libraryVC.navigationItem.largeTitleDisplayMode = .always
        libraryVC.navigationItem.title = "Your Library"
        libraryVC.tabBarItem = UITabBarItem(title: "Your Library", image: UIImage(systemName: "books.vertical"), selectedImage: UIImage(systemName: "books.vertical.fill"))
        let nav = UINavigationController(rootViewController: libraryVC)
        nav.navigationBar.tintColor = .white
        nav.navigationBar.barStyle = .black
        return nav
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = UIColor(named: "tabbarColor")!
        tabBar.tintColor = .white
        setViewControllers([homeNavVC,SearchNavVC,LibraryNavVC], animated: false)
    }


}
