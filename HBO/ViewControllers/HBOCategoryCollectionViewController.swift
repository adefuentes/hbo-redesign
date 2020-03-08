//
//  HBOCategoryCollectionViewController.swift
//  HBO
//
//  Created by Angel Fuentes on 29/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

class HBOCategoryCollectionViewController: UIViewController {

    private var animateImages: [UIImageView] = []
    private var layout: UICollectionViewFlowLayout!
    private var categoryLabel: UILabel!
    private var collection: UICollectionView!
    private var detailView: HBOPreviewContentView!
    private var backgroundView: UIImageView!
    private var selectedContent: HBOContent!
    private var indexOfCellBeforeDragging = 0
    
    public var selectedIndexPath: IndexPath!
    public var category: String!
    public var contents: [HBOContent] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collection.scrollToItem(at: selectedIndexPath, at: .right, animated: false)
        
        animateImages.forEach {
            $0.removeFromSuperview()
        }
        
        UIView.animate(withDuration: 0.1) {
            self.collection.alpha = 1
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        selectedContent = contents[selectedIndexPath.row]
        categoryLabel.text = category
        detailView.parse(selectedContent)
        addTranslucentView()
        
    }
    
}

extension HBOCategoryCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? HBOImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.downloaded(from: "\(kUIImagePathW500)\(contents[indexPath.row].poster_path ?? "")", contentMode: .scaleAspectFill)
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = round(collectionView.frame.height * 9.5 / 16)
        
        return CGSize(width: width, height: collectionView.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 16.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let width = round(collectionView.frame.height * 9.5 / 16)
        let margins = collectionView.frame.width - width
        
        return UIEdgeInsets(top: 0, left: margins / 2, bottom: 0, right: margins / 2)
    }
    
}

extension HBOCategoryCollectionViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureCollectionViewLayoutItemSize()
    }
    
    func calculateSectionInset() -> CGFloat {
//        let width = round(collection.frame.height * 9.5 / 16)
//        let margins = collection.frame.width - width
        return 16.0
    }
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset()
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        layout.itemSize = CGSize(width: layout.collectionView!.frame.size.width - inset * 2, height: layout.collectionView!.frame.size.height)
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = layout.itemSize.width
        let proportionalOffset = layout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = collection.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        targetContentOffset.pointee = scrollView.contentOffset
        
        let indexOfMajorCell = self.indexOfMajorCell()
        
        print(indexOfMajorCell)
        
        let dataSourceCount = collectionView(collection!, numberOfItemsInSection: 0)
        let swipeVelocityThreshold: CGFloat = 0.5
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            
            /*let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = layout.itemSize.width * CGFloat(snapToIndex)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)*/
            let indexPath = IndexPath(row: indexOfMajorCell + 1, section: 0)
            layout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            if indexOfMajorCell + 1 == contents.count - 1 {
                return
            }
            
            selectedContent = contents[indexOfMajorCell + 1]
            detailView.parse(selectedContent)
            addTranslucentView()
            
        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            layout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            selectedContent = contents[indexPath.row]
            detailView.parse(selectedContent)
            addTranslucentView()
        }
    }
    
}

extension HBOCategoryCollectionViewController {
    
    func addTranslucentView() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if backgroundView != nil {
            
            UIView.animate(withDuration: 0.05, animations: {
                
                self.backgroundView.alpha = 0
                
            }) { _ in
                
                self.backgroundView.removeFromSuperview()
                self.backgroundView = nil
                self.backgroundView = UIImageView()
                self.backgroundView.downloaded(from: "\(kUIImagePathW500)\(self.selectedContent.poster_path ?? "")", contentMode: .scaleAspectFill)
                self.backgroundView.addSubview(blurEffectView)
                self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
                
                self.view.addSubview(self.backgroundView)
                self.view.sendSubviewToBack(self.backgroundView)
                self.view.addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: self.backgroundView)
                self.view.addConstraintsWithFormat(visualFormat: "V:|[v0]|", views: self.backgroundView)
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.backgroundView.alpha = 1
                })
                
            }
            
        } else {
            
            backgroundView = nil
            backgroundView = UIImageView()
            backgroundView.downloaded(from: "\(kUIImagePathW500)\(selectedContent.poster_path ?? "")", contentMode: .scaleAspectFill)
            backgroundView.addSubview(blurEffectView)
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(backgroundView)
            view.sendSubviewToBack(backgroundView)
            view.addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: backgroundView)
            view.addConstraintsWithFormat(visualFormat: "V:|[v0]|", views: backgroundView)
            
        }
        
        
    }
    
    func setupView() {
        
        view.backgroundColor = .darkBackground
        
        let backFakeView = UIView()
        let gradientView = UIView()
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (view.frame.height / 2) - 180)
        gradientLayer.colors = [UIColor.darkBackground.withAlphaComponent(0).cgColor, UIColor.darkBackground.cgColor]
        
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        backFakeView.translatesAutoresizingMaskIntoConstraints = false
        backFakeView.backgroundColor = .darkBackground
        
        layout = UICollectionViewFlowLayout()
        collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collection.alpha = 0
        collection.register(HBOImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        collection.tag = 99
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        detailView = HBOPreviewContentView()
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.backgroundColor = .darkBackground
        
        categoryLabel = UILabel()
        categoryLabel.textColor = .white
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(gradientView)
        view.addSubview(backFakeView)
        view.addSubview(categoryLabel)
        view.addSubview(collection)
        view.addSubview(detailView)
        
        view.addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: gradientView)
        view.addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: collection)
        view.addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: detailView)
        view.addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: backFakeView)
        view.addConstraintsWithFormat(visualFormat: "H:|-16-[v0]-16-|", views: categoryLabel)
        view.addConstraintsWithFormat(visualFormat: "V:|-[v0(50)]-[v1]-[v2(180)]-|", views: categoryLabel, collection, detailView)
        view.addConstraintsWithFormat(visualFormat: "V:[v0][v1]", views: gradientView, detailView)
        view.addConstraintsWithFormat(visualFormat: "V:[v0]|", views: backFakeView)
        
        view.addConstraint(NSLayoutConstraint(item: gradientView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: backFakeView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: detailView,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
        
    }
    
}
