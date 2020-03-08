//
//  HBOPagesViewController.swift
//  HBO
//
//  Created by Angel Fuentes on 09/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

class HBOPagesViewController: UIViewController {

    var titleList: String!
    var titleLabel: UILabel?
    var collection: UICollectionView?
    var selectedIndexPath: IndexPath!
    var contents: [HBOContent] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collection?.scrollToItem(at: selectedIndexPath, at: .right, animated: false)
        UIView.animate(withDuration: 0.2) {
            self.collection?.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        titleLabel?.text = titleList
        
    }

}

extension HBOPagesViewController: HBOContentViewCellDelegate {
    
    func dismissView() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension HBOPagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fullInfoCell", for: indexPath) as? HBOContentViewCell else {
            return UICollectionViewCell()
        }
        
        cell.backDropImage.downloaded(from: "\(kUIImagePathW500)\(contents[indexPath.row].backdrop_path ?? "")", contentMode: .scaleAspectFill)
        cell.posterImage.downloaded(from: "\(kUIImagePathW500)\(contents[indexPath.row].poster_path ?? "")", contentMode: .scaleAspectFill)
        cell.titleLabel.text = contents[indexPath.row].title ?? ""
        cell.tagLineLabel.text = contents[indexPath.row].overview ?? ""
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.bounds.width - 8, height: view.bounds.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
}

extension HBOPagesViewController {
    
    func setupView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        titleLabel = UILabel(frame: .zero)
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .center
        
        collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection?.isPagingEnabled = true
        collection?.dataSource = self
        collection?.delegate = self
        collection?.register(HBOContentViewCell.self, forCellWithReuseIdentifier: "fullInfoCell")
        collection?.backgroundColor = .clear
        collection?.alpha = 0
        
        view.addSubview(blurEffectView)
        view.addSubview(titleLabel!)
        view.addSubview(collection!)
        
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        collection?.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: collection!)
        view.addConstraintsWithFormat(visualFormat: "H:|-[v0]-|", views: titleLabel!)
        view.addConstraintsWithFormat(visualFormat: "V:|-[v0(50)]", views: titleLabel!)
        view.addConstraintsWithFormat(visualFormat: "V:|[v0]|", views: collection!)
        
    }
    
}
