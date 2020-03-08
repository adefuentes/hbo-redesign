//
//  HBORightIconButton.swift
//  HBO
//
//  Created by Angel Fuentes on 01/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

class HBORightIconButton: HBORoundButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 35), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
    
}
