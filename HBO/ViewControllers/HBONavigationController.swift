//
//  HBONavigationController.swift
//  HBO
//
//  Created by Angel Fuentes on 05/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

class HBONavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barStyle = .black
        navigationBar.topItem?.titleView = UIImageView(image: UIImage(named: "makefg"))
        
    }
    

}
