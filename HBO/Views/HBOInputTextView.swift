//
//  HBOInputTextView.swift
//  HBO
//
//  Created by Angel Fuentes on 30/09/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

class HBOInputTextView: UIView {
    
    var input: UITextField!
    var text: String {
        get {
            return input.text ?? ""
        }
        
        set {
            input.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HBOInputTextView {
    
    func setupViews() {
        
        input = UITextField()
        
        backgroundColor = UIColor(displayP3Red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
        input.backgroundColor = .clear
        input.textColor = UIColor.white
        input.keyboardAppearance = .dark
        
        addSubview(input)
        
        input.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: [], metrics: nil, views: ["v0": input]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: [], metrics: nil, views: ["v0": input]))
        
        layer.cornerRadius = 7
        
    }
    
}
