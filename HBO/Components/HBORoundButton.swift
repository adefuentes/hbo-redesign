//
//  HBORoundButton.swift
//  HBO
//
//  Created by Angel Fuentes on 09/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

class HBORoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HBORoundButton {
    
    func setupView() {
        
        self.layer.cornerRadius = 25
        
    }
    
}
