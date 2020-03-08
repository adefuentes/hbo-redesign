//
//  HBOLoginButton.swift
//  HBO
//
//  Created by Angel Fuentes on 01/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit


class HBOLoginButton: HBORightIconButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitle("Entrar", for: .normal)
        setImage(UIImage(named: "right-arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        tintColor = .white
        backgroundColor = .hboBlue
        layer.cornerRadius = 25
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
