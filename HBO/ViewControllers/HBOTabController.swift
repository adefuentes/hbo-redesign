//
//  HBOTabController.swift
//  HBO
//
//  Created by Angel Fuentes on 02/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

class HBOTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barStyle = .black
        tabBar.tintColor = .hboBlue
        
        initSubviewControllers()
        
    }

}

extension HBOTabController {
    
    func initSubviewControllers() {
        
        var viewControllers: [UIViewController] = []
        
        let layout = UICollectionViewFlowLayout()
        let viewController = HBOContentsViewController(collectionViewLayout: layout)
        let tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home-filled"))
        
        let layoutKids = UICollectionViewFlowLayout()
        let viewControllerKids = HBOContentsViewController(collectionViewLayout: layoutKids)
        let tabBarItemKids = UITabBarItem(title: "Kids", image: UIImage(named: "kids"), selectedImage: UIImage(named: "kids-filled"))
        
        let layoutMyList = UICollectionViewFlowLayout()
        let viewControllerMyList = HBOContentsViewController(collectionViewLayout: layoutMyList)
        let tabBarItemMyList = UITabBarItem(title: "Mi lista", image: UIImage(named: "list"), selectedImage: UIImage(named: "list-filled"))
        
        let searchViewController = UIViewController()
        let tabBarItemSearch = UITabBarItem(title: "Buscar", image: UIImage(named: "search"), selectedImage: UIImage(named: "search-filled"))
        
        let userViewController = UIViewController()
        let tabBarItemUser = UITabBarItem(title: "Perfil", image: UIImage(named: "user"), selectedImage: UIImage(named: "user-filled"))
        
        viewController.tabBarItem = tabBarItem
        viewControllers.append(viewController)
        
        viewControllerKids.tabBarItem = tabBarItemKids
        viewControllers.append(viewControllerKids)
        
        viewControllerMyList.tabBarItem = tabBarItemMyList
        viewControllers.append(viewControllerMyList)
        
        searchViewController.tabBarItem = tabBarItemSearch
        viewControllers.append(searchViewController)
        
        userViewController.tabBarItem = tabBarItemUser
        viewControllers.append(userViewController)
        
        viewControllers = viewControllers.compactMap {
            return HBONavigationController(rootViewController: $0)
        }
        
        self.setViewControllers(viewControllers, animated: true)
        
    }
    
}
