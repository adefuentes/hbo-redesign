//
//  HBOCollectionTransition.swift
//  HBO
//
//  Created by Angel Fuentes on 04/11/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

class HBOCollectionTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let originFrames: [CGRect]
    private let images: [UIImage]
    private let visibleIndexes: [Int]
    private let index: Int
    
    private let kCOLLECTION_TAG = 99
    
    init(originFrames: [CGRect], images: [UIImage], visibleIndexes: [Int], index: Int) {
        self.originFrames = originFrames
        self.images = images
        self.index = index
        self.visibleIndexes = visibleIndexes
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let _ = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true),
            let collection = toVC.view.viewWithTag(kCOLLECTION_TAG) as? UICollectionView
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        
        snapshot.frame = originFrames.first ?? .zero
        snapshot.layer.masksToBounds = true
        snapshot.alpha = 0
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        
        let height = collection.frame.height
        let width = round(height * 9.5 / 16)
        let imageSize = CGSize(width: width, height: height)
        
        var imageViews: [UIImageView] = []
        
        for (key, image) in images.enumerated() {
            
            let imageView = UIImageView(frame: originFrames[key])
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            
            containerView.addSubview(imageView)
            
            imageViews.append(imageView)
            
        }
        
        print("## REAL KEY: \(index)")
        
        let _key = visibleIndexes.index(of: index) ?? 0
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: 0.2, animations: {
            
            for (key, value) in imageViews.enumerated() {
                
                let selectedX = toVC.view.center.x - (imageSize.width/2)
                
                print("## KEY: \(key)")
                print("## _KEY: \(_key)")
                
                if key < _key {
                    let inx = _key - key
                    let x = selectedX - ((imageSize.width)*CGFloat(inx)) - (16*CGFloat(inx))
                    print("## < x: \(x)")
                    value.frame = CGRect(x: x, y: collection.frame.origin.y, width: imageSize.width, height: imageSize.height)
                } else if key == _key {
                    print("## = x: \(selectedX)")
                    value.frame = CGRect(x: selectedX, y: collection.frame.origin.y, width: imageSize.width, height: imageSize.height)
                } else {
                    let inx = key - _key
                    let x = selectedX + (imageSize.width*CGFloat(inx)) + (16*CGFloat(inx))
                    print("## > x: \(x)")
                    value.frame = CGRect(x: x, y: collection.frame.origin.y, width: imageSize.width, height: imageSize.height)
                }
                
            }
            
            snapshot.alpha = 1
            
        }, completion: { _ in
            toVC.view.isHidden = false
            imageViews.forEach {
                $0.removeFromSuperview()
            }
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
    
}
