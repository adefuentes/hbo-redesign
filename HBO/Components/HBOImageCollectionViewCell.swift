//
//  HBOImageCollectionViewCell.swift
//  HBO
//
//  Created by Angel Fuentes on 06/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

class HBOImageCollectionViewCell: UICollectionViewCell {
    
    public var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HBOImageCollectionViewCell {
    
    func setupViews() {
        
        self.layer.cornerRadius = 5
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: [],
                                                      metrics: nil, views: ["v0": imageView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [],
                                                      metrics: nil, views: ["v0": imageView]))
        
    }
    
}
