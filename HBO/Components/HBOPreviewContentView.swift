//
//  HBOPreviewContentView.swift
//  HBO
//
//  Created by Angel Fuentes on 03/11/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

class HBOPreviewContentView: UIView {
    
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    var sinopsisLabel: UILabel!
    var showButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func parse(_ model: HBOContent) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.titleLabel.alpha = 0
            self.dateLabel.alpha = 0
            self.sinopsisLabel.alpha = 0
            
        }) { _ in
            
            self.titleLabel.text = model.title
            self.dateLabel.text = model.release_date
            self.sinopsisLabel.text = model.overview
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.titleLabel.alpha = 1
                self.dateLabel.alpha = 1
                self.sinopsisLabel.alpha = 1
                
            })
            
        }
        
    }
    
}

extension HBOPreviewContentView {
    
    func setupViews() {
        
        titleLabel = UILabel()
        dateLabel = UILabel()
        sinopsisLabel = UILabel()
        showButton = UIButton()
        
        titleLabel.textColor = .white
        dateLabel.textColor = .darkGray
        sinopsisLabel.textColor = .darkGray
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        dateLabel.font = dateLabel.font.withSize(14)
        sinopsisLabel.font = sinopsisLabel.font.withSize(14)
        
        titleLabel.numberOfLines = 2
        sinopsisLabel.numberOfLines = 2
        
        showButton.backgroundColor = .hboBlue
        showButton.setTitleColor(.white, for: .normal)
        showButton.setTitle("Reproducir", for: .normal)
        showButton.layer.cornerRadius = 25
        
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(sinopsisLabel)
        addSubview(showButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        sinopsisLabel.translatesAutoresizingMaskIntoConstraints = false
        showButton.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintsWithFormat(visualFormat: "H:|-16-[v0]-16-|", views: titleLabel)
        addConstraintsWithFormat(visualFormat: "H:|-16-[v0]-16-|", views: dateLabel)
        addConstraintsWithFormat(visualFormat: "H:|-16-[v0]-16-|", views: sinopsisLabel)
        addConstraintsWithFormat(visualFormat: "H:|-16-[v0]-16-|", views: showButton)
        
        addConstraintsWithFormat(visualFormat: "V:|-[v0(25)]-5-[v1(20)]-5-[v2]-16-[v3(50)]-|", views: titleLabel, dateLabel, sinopsisLabel, showButton)
        
    }
    
}
