//
//  HBOContentsViewController.swift
//  HBO
//
//  Created by Angel Fuentes on 05/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

class HBOContentsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    internal let apiController: HBOAPIClient = HBOAPIClient(publicKey: kAPIMOVIEDB_Key, privateKey: kAPPPrivate_Key)
    internal var originalFrames: [CGRect]!
    internal var selectedIndexes: [Int]!
    internal var images: [UIImage]!
    internal var selectedIndex: Int = 0
    internal var contents: [[HBOContent]] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    internal let arrCat = ["",
                           "Continuar viendo...",
                           "Las películas más vistas",
                           "Las series más vistas",
                           "Añadidos recientemente",
                           "Recomendaciones",
                           "Películas por género",
                           "Series por género",
                           "Terror",
                           "#TUMUNDO",
                           "En familia"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .darkBackground
        collectionView.register(HBORecentContentCell.self, forCellWithReuseIdentifier: "bigHorizontalCollectionCell")
        collectionView.register(HBOSmallHorizCollectionInCell.self, forCellWithReuseIdentifier: "smallHorizontalCollectionCell")
        collectionView.register(HBOHorizCollectionViewInCell.self, forCellWithReuseIdentifier: "horizontalCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        navigationController?.hidesBarsOnSwipe = true
        
        let titleImage = UIImageView(image: UIImage(named: "makefg"))
        titleImage.contentMode = .scaleAspectFit
        
        
        navigationItem.titleView = titleImage
        
        getContents()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: HBOHorizCollectionViewInCell!
        
        if indexPath.row == 0 {
            
            guard let aux = collectionView.dequeueReusableCell(withReuseIdentifier: "bigHorizontalCollectionCell", for: indexPath) as? HBOHorizCollectionViewInCell else {
                return UICollectionViewCell()
            }
            
            cell = aux
            
        } else if indexPath.row == 5 || indexPath.row == 6 {
            
            guard let aux = collectionView.dequeueReusableCell(withReuseIdentifier: "smallHorizontalCollectionCell", for: indexPath) as? HBOHorizCollectionViewInCell else {
                return UICollectionViewCell()
            }
            
            cell = aux
            
        } else {
            
            guard let aux = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontalCollectionCell", for: indexPath) as? HBOHorizCollectionViewInCell else {
                return UICollectionViewCell()
            }
            
            cell = aux
            
        }
        
        cell.titleList.text = arrCat[indexPath.row]
        cell.hbo_delegate = self
        cell.contents = contents[indexPath.row]
        cell.backgroundColor = UIColor.darkBackground
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            return CGSize(width: collectionView.bounds.width, height: 500)
        } else if indexPath.row == 5 || indexPath.row == 6 {
            return CGSize(width: collectionView.frame.width, height: 150)
        }
        return CGSize(width: collectionView.frame.width, height: 300)
    }

}

extension HBOContentsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HBOCollectionTransition(originFrames: self.originalFrames, images: self.images, visibleIndexes: selectedIndexes, index: selectedIndex)
    }
    
}

extension HBOContentsViewController: HBOHorizCollectionDelegate {
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//
//        if let touch = touches.first {
//            if let cell = touch.view as? HBOImageCollectionViewCell {
//                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//            }
//        }
//
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//
//        if let touch = touches.first {
//            if let cell = touch.view as? HBOImageCollectionViewCell {
//                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
//            }
//        }
//
//    }
    
    func didSelectedContent(_ content: HBOContent, indexPath: IndexPath, cell: HBOImageCollectionViewCell, row: HBOHorizCollectionViewInCell) {
        
        let viewController = HBOCategoryCollectionViewController()
        viewController.contents = row.contents
        viewController.category = row.titleList.text
        viewController.modalTransitionStyle = .crossDissolve
        viewController.transitioningDelegate = self
        viewController.selectedIndexPath = indexPath
        
        images = []
        originalFrames = []
        selectedIndexes = []
        selectedIndex = indexPath.row
        
        if var visibleCells = row.collectionView.visibleCells as? [HBOImageCollectionViewCell] {
            visibleCells.sort {
                return $0.frame.origin.x < $1.frame.origin.x
            }
            visibleCells.forEach {
                images.append($0.imageView.image ?? UIImage())
                selectedIndexes.append(row.collectionView.indexPath(for: $0)?.row ?? 0)
                selectedIndexes.sort()
                originalFrames.append(row.collectionView.convert($0.frame, to: view))
            }
        }
        
        present(viewController, animated: true, completion: nil)
        
    }
    
}

extension HBOContentsViewController {
    
    func getContents() {
        
        var aux: [[HBOContent]] = [] {
            didSet {
                if aux.count == arrCat.count {
                    self.contents = aux
                }
            }
        }
        
        for (i, _) in arrCat.enumerated() {
        
            apiController.send(HBOGetList(language: "es-ES", page: i+1)) { response in
                
                switch response {
                case .success(let dataContainer):
                    
                    DispatchQueue.main.async {
                        aux.append(dataContainer.results)
                    }
                    
                case .failure(let error):
                    print(error)
                }
                
            }
        }
        
        
        
    }
    
}
