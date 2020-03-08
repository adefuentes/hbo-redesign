//
//  HBOReplayButton.swift
//  HBO
//
//  Created by Angel Fuentes on 28/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

class HBOReplayButton: UIView {
    
    private var button: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HBOReplayButton {
    
    func setupView() {
        
        button = UIButton()
        
        button?.setImage(UIImage(named: "circle-play"), for: .normal)
        button?.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(button!)
        
        addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: button!)
        addConstraintsWithFormat(visualFormat: "V:|[v0]|", views: button!)
        
    }
    
}
