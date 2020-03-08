//
//  HBOContentViewController.swift
//  HBO
//
//  Created by Angel Fuentes on 08/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

var kTRANSLATION_VIEW: CGFloat = UIApplication.shared.statusBarFrame.height + 40
var kSCALE_VIEW: CGFloat = 0.90

let offset_HeaderStop:CGFloat = 250 - kTRANSLATION_VIEW
let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

protocol HBOContentViewCellDelegate {
    func dismissView()
}

class HBOContentViewCell: UICollectionViewCell {

    internal var view: UIView!
    internal var scrollView: UIScrollView!
    
    internal var backDropImage: UIImageView!
    internal var posterImage: UIImageView! {
        didSet {
            
            let imageView = UIImageView(image: posterImage.image)
            let effect = UIBlurEffect(style: .dark)
            let effectView = UIVisualEffectView(effect: effect)
            
            effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            imageView.addSubview(effectView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.alpha = 0.5
            
            view.addSubview(imageView)
            
            view.addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: imageView)
            view.addConstraintsWithFormat(visualFormat: "V:|[v0]|", views: imageView)
            
        }
    }
    
    internal var titleLabel: UILabel!
    internal var tagLineLabel: UILabel!
    
    internal var showButton: HBORightIconButton!
    internal var trailerButton: HBORoundButton!
    internal var addToMyListButton: HBORoundButton!
    
    internal var dateLabel: UILabel!
    internal var sinopsisLabel: UILabel!
    internal var collectionButtons: UIButton!
    
    internal var dismissButton: UIButton!
    
    fileprivate var panGesture: UIPanGestureRecognizer!
    fileprivate var changedTranslation: CGFloat = kTRANSLATION_VIEW
    
    fileprivate var blurView: UIVisualEffectView!
    
    public var delegate: HBOContentViewCellDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        dismissButton.addTarget(self, action: #selector(dismissView(_:)), for: .touchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissView(_ sender: UIButton) {
        
        delegate.dismissView()
        
    }
    
}

extension HBOContentViewCell: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let offset = scrollView.contentOffset.y
        
        if offset >= kTRANSLATION_VIEW / 3 {
            scrollView.setContentOffset(CGPoint(x: 0, y: kTRANSLATION_VIEW), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        var transformView = CATransform3DIdentity
        
        let maxi = self.center.y + kTRANSLATION_VIEW
        
        var pos = (offset < 0) ? 0 : offset
        pos = (pos > kTRANSLATION_VIEW) ? kTRANSLATION_VIEW : pos
            
        view.center.y = maxi - pos
            
        let percentProgress = (pos * 100) / kTRANSLATION_VIEW
        let currentScale = kSCALE_VIEW + ((1 - kSCALE_VIEW) * (percentProgress / 100))
        let newScale = (currentScale > 1) ? 1 : currentScale
        
        transformView = CATransform3DScale(transformView, newScale, newScale, 200)
        view.layer.transform = transformView
        
        if newScale == 1 {
            view.layer.cornerRadius = 0
            if let parent = self.delegate as? HBOPagesViewController {
                parent.collection?.isScrollEnabled = false
            }
            
            if offset < 0 {
                
                let headerScaleFactor:CGFloat = -(offset) / backDropImage.bounds.height
                let headerSizevariation = ((backDropImage.bounds.height * (1.0 + headerScaleFactor)) - backDropImage.bounds.height)/2.0
                headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
                headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
                
                backDropImage.layer.transform = headerTransform
                
                
                
            } else {
                headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
                
                //            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
                //            headerLabel.layer.transform = labelTransform
                
                //  ------------ Blur
                
                blurView.alpha = min(1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
                
                // Avatar -----------
                
                let avatarScaleFactor = (min(offset_HeaderStop, offset)) / posterImage.bounds.height / 1.4
                let avatarSizeVariation = ((posterImage.bounds.height * (1.0 + avatarScaleFactor)) - posterImage.bounds.height) / 2.0
                avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
                avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
                
                if offset <= offset_HeaderStop {
                    
                    if posterImage.layer.zPosition < backDropImage.layer.zPosition{
                        backDropImage.layer.zPosition = 0
                    }
                    
                }else {
                    if posterImage.layer.zPosition >= backDropImage.layer.zPosition{
                        backDropImage.layer.zPosition = 2
                        dismissButton.layer.zPosition = 3
                    }
                }
                
                backDropImage.layer.transform = headerTransform
                posterImage.layer.transform = avatarTransform
            }
            
            
        } else {
            view.layer.cornerRadius = 5
            if let parent = self.delegate as? HBOPagesViewController {
                parent.collection?.isScrollEnabled = true
            }
            
            if offset < 0 {
                var pos = (offset < 0) ? 0 : offset
                pos = (pos > kTRANSLATION_VIEW) ? kTRANSLATION_VIEW : pos
                
                view.center.y = maxi - offset
                
                if offset < -180 {
                    dismissView(UIButton())
                }
                
            }
            
        }
        
    }
    
}

extension HBOContentViewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension HBOContentViewCell {
    
    func setupLabel(withTextColor textColor: UIColor = .white) -> UILabel {
        
        let label = UILabel()
        
        label.textAlignment = .center
        label.textColor = textColor
        label.numberOfLines = 3
        
        return label
        
    }
    
    func setupViews() {
        
        let darkBlur = UIBlurEffect(style: UIBlurEffect.Style.dark)
        
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.alpha = 0
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .darkBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        
        backDropImage = UIImageView()
        posterImage = UIImageView()
        
        posterImage.layer.cornerRadius = 5
        posterImage.layer.borderColor = UIColor.darkBackground.cgColor
        posterImage.layer.borderWidth = 5
        
        backDropImage.clipsToBounds = true
        posterImage.clipsToBounds = true
        
        titleLabel = setupLabel()
        tagLineLabel = setupLabel(withTextColor: .lightGray)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 26)
        
        showButton = HBORightIconButton()
        trailerButton = HBORoundButton()
        addToMyListButton = HBORoundButton()
        
        showButton.backgroundColor = .hboBlue
        showButton.setTitle("REPRODUCIR", for: .normal)
        showButton.setTitleColor(.white, for: .normal)
        
        trailerButton.layer.borderColor = UIColor.white.cgColor
        trailerButton.layer.borderWidth = 3
        trailerButton.setTitle("TRAILER", for: .normal)
        trailerButton.setTitleColor(.white, for: .normal)
        
        addToMyListButton.layer.borderColor = UIColor.white.cgColor
        addToMyListButton.layer.borderWidth = 3
        addToMyListButton.setTitle("AÑADIR", for: .normal)
        addToMyListButton.setTitleColor(.white, for: .normal)
        
        dismissButton = UIButton(type: .system)
        dismissButton.setTitle("Cerrar", for: .normal)
        dismissButton.setTitleColor(.white, for: .normal)
        
        addSubview(view)
        
        view.addSubview(backDropImage)
        view.addSubview(scrollView)
        view.addSubview(dismissButton)
        
        scrollView.addSubview(posterImage)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(tagLineLabel)
        scrollView.addSubview(showButton)
        scrollView.addSubview(trailerButton)
        scrollView.addSubview(addToMyListButton)
        
        backDropImage.addSubview(blurView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        backDropImage.translatesAutoresizingMaskIntoConstraints = false
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLineLabel.translatesAutoresizingMaskIntoConstraints = false
        showButton.translatesAutoresizingMaskIntoConstraints = false
        trailerButton.translatesAutoresizingMaskIntoConstraints = false
        addToMyListButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: scrollView)
        view.addConstraintsWithFormat(visualFormat: "V:|[v0]|", views: scrollView)
        
        view.addConstraintsWithFormat(visualFormat: "H:[v0]-16-|", views: dismissButton)
        view.addConstraintsWithFormat(visualFormat: "V:|-[v0]", views: dismissButton)
        
        view.addConstraintsWithFormat(visualFormat: "V:|[v0(250)]", views: backDropImage)
        view.addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: backDropImage)
        
        scrollView.addConstraintsWithFormat(visualFormat: "V:|-120-[v0(250)]-24-[v1]-16-[v2]-32-[v3(50)]-16-[v4(50)]-300-|", views: posterImage, titleLabel, tagLineLabel, showButton, trailerButton)
        
        scrollView.addConstraintsWithFormat(visualFormat: "H:[v0(170)]", views: posterImage)
        scrollView.addConstraintsWithFormat(visualFormat: "H:|-[v0]-|", views: titleLabel)
        scrollView.addConstraintsWithFormat(visualFormat: "H:|-[v0]-|", views: tagLineLabel)
        scrollView.addConstraintsWithFormat(visualFormat: "H:|-[v0]-|", views: showButton)
        
        backDropImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backDropImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        tagLineLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        tagLineLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        showButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        showButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        
        trailerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        addToMyListButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        
        scrollView.addConstraint(NSLayoutConstraint(item: posterImage,
                                                    attribute: .centerX,
                                                    relatedBy: .equal,
                                                    toItem: scrollView,
                                                    attribute: .centerX, multiplier: 1, constant: 0))
        
        scrollView.addConstraint(NSLayoutConstraint(item: addToMyListButton,
                                                    attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: trailerButton,
                                                    attribute: .top, multiplier: 1, constant: 0))
        
        scrollView.addConstraint(NSLayoutConstraint(item: addToMyListButton,
                                                    attribute: .height,
                                                    relatedBy: .equal,
                                                    toItem: trailerButton,
                                                    attribute: .height, multiplier: 1, constant: 0))
        
        scrollView.addConstraint(NSLayoutConstraint(item: addToMyListButton,
                                                    attribute: .leading,
                                                    relatedBy: .equal,
                                                    toItem: scrollView,
                                                    attribute: .centerX, multiplier: 1, constant: 4))
        
        scrollView.addConstraint(NSLayoutConstraint(item: trailerButton,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: scrollView,
                                                    attribute: .centerX, multiplier: 1, constant: -4))
        
        var transformView = CATransform3DIdentity
        
        transformView = CATransform3DScale(transformView, kSCALE_VIEW, kSCALE_VIEW, 200)
        
        view.layer.transform = transformView
        view.center.y += kTRANSLATION_VIEW
        
        blurView.frame = backDropImage.bounds
        
    }
    
}
