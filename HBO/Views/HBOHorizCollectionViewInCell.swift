//
//  HBOHorizCollectionViewInCell.swift
//  HBO
//
//  Created by Angel Fuentes on 06/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

protocol HBOHorizCollectionDelegate {
    func didSelectedContent(_ content: HBOContent, indexPath: IndexPath, cell: HBOImageCollectionViewCell, row: HBOHorizCollectionViewInCell)
}

class HBOHorizCollectionViewInCell: UICollectionViewCell {
    
    enum Orientation {
        case horizontal
        case vertical
    }
    
    internal var layout: UICollectionViewFlowLayout!
    internal var titleList: UILabel!
    internal var collectionView: UICollectionView!
    internal var collectionSize: CGSize?
    internal var uriPath: String = kUIImagePathW500
    internal var imgOrientation: HBOHorizCollectionViewInCell.Orientation = .vertical
    internal var cornerRadiusInCell: CGFloat = 5
    
    public var hbo_delegate: HBOHorizCollectionDelegate?
    
    public var contents: [HBOContent] = [] {
        didSet {
            collectionView.reloadData()
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

extension HBOHorizCollectionViewInCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? HBOImageCollectionViewCell {
            hbo_delegate?.didSelectedContent(contents[indexPath.row], indexPath: indexPath, cell: cell, row: self)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath) as? HBOImageCollectionViewCell  else {
            return UICollectionViewCell()
        }
        
        let content = contents[indexPath.row]
        
        if let posterPath = content.poster_path {
            cell.imageView.downloaded(from: "\(uriPath)\(posterPath)", contentMode: .scaleAspectFill)
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 170, height: 250)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
    }
    
}

extension HBOHorizCollectionViewInCell {
    
    func setupViews() {
        
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .darkBackground
        collectionView.register(HBOImageCollectionViewCell.self, forCellWithReuseIdentifier: "contentCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        titleList = UILabel()
        titleList.textColor = .white
        
        addSubview(titleList)
        addSubview(collectionView)
        
        titleList.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: [],
                                                      metrics: nil, views: ["v0": collectionView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: [],
                                                      metrics: nil, views: ["v0": titleList]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-[v1]-|", options: [],
                                                      metrics: nil, views: ["v0": titleList, "v1": collectionView]))
        
    }
    
}

class HBOSmallHorizCollectionInCell: HBOHorizCollectionViewInCell {
    
    var genres: [String] = ["Acción", "Aventura", "Comedia", "Romance", "Ciencia ficción","Fansasia", "Terror"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.isPagingEnabled = true
        collectionView.register(HBOGenreViewCell.self, forCellWithReuseIdentifier: "genreCell")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as? HBOGenreViewCell  else {
            return UICollectionViewCell()
        }
        
        let content = contents[indexPath.row]
        
        if let posterPath = content.backdrop_path {
            cell.imageView.downloaded(from: "\(uriPath)\(posterPath)", contentMode: .scaleAspectFill)
        }
        cell.imageView.layer.cornerRadius = 10
        cell.titleLabel.text = genres[indexPath.row]
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width / 2), height: 100)
        
    }
    
}

class HBORecentContentCell: HBOHorizCollectionViewInCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        collectionView.isPagingEnabled = true
        collectionView.register(HBOBigContentCell.self, forCellWithReuseIdentifier: "bigContentCell")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bigContentCell", for: indexPath) as? HBOBigContentCell  else {
            return UICollectionViewCell()
        }
        
        let content = contents[indexPath.row]
        if let posterPath = content.poster_path {
            cell.imageView.downloaded(from: "\(uriPath)\(posterPath)", contentMode: .scaleAspectFill)
            cell.posterImage.downloaded(from: "\(uriPath)\(posterPath)", contentMode: .scaleAspectFill)
        }
        
        cell.progressBar.setProgress(70, animated: true)
        cell.titleContent.text = content.title ?? ""
        cell.infoLabel.text = "8min de 1h y 52min"
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 500)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
}

class HBOGenreViewCell: HBOImageCollectionViewCell {
    
    public var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = titleLabel.font.withSize(22)
        titleLabel.textAlignment = .center
        
        self.addSubview(blurEffectView)
        self.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: titleLabel)
        addConstraintsWithFormat(visualFormat: "V:|[v0]|", views: titleLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HBOBigContentCell: HBOImageCollectionViewCell {
    
    public let posterImage: UIImageView = {
       
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        
        return imageView
        
    }()
    
    private let infoWrapper: UIView = {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        gradientLayer.colors = [UIColor.darkBackground.withAlphaComponent(0).cgColor,
                                UIColor.darkBackground.withAlphaComponent(0.2).cgColor,
                                UIColor.darkBackground.withAlphaComponent(0.5).cgColor,
                                UIColor.darkBackground.withAlphaComponent(0.7).cgColor,
                                UIColor.darkBackground.withAlphaComponent(0.7).cgColor,
                                UIColor.darkBackground.withAlphaComponent(0.7).cgColor,
                                UIColor.darkBackground.withAlphaComponent(0.9).cgColor,
                                UIColor.darkBackground.cgColor]
        
        let view = UIView()
        view.layer.addSublayer(gradientLayer)
        
        return view
        
    }()
    
    public let titleContent: UILabel = {
        
        let label = UILabel()
        
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        
        return label
        
    }()
    
    public let infoLabel: UILabel = {
       
        let label = UILabel()
        
        label.textColor = .white
        label.font = label.font.withSize(14)
        
        return label
        
    }()
    
    public let progressBar: UIProgressView = {
        
        let progressView = UIProgressView(progressViewStyle: UIProgressView.Style.bar)
        
        progressView.progressTintColor = .hboBlue
        progressView.trackTintColor = UIColor.black.withAlphaComponent(0.7)
        
        return progressView
        
    }()
    
    public let replayButton: HBOReplayButton = {
        let repButton = HBOReplayButton()
        
        return repButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(posterImage)
        addSubview(infoWrapper)
        infoWrapper.addSubview(titleContent)
        infoWrapper.addSubview(infoLabel)
        infoWrapper.addSubview(replayButton)
        infoWrapper.addSubview(progressBar)
        
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        infoWrapper.translatesAutoresizingMaskIntoConstraints = false
        titleContent.translatesAutoresizingMaskIntoConstraints = false
        replayButton.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: posterImage)
        addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: infoWrapper)
        addConstraintsWithFormat(visualFormat: "V:[v0(100)]|", views: infoWrapper)
        addConstraintsWithFormat(visualFormat: "V:|[v0]|", views: posterImage)
        
        infoWrapper.addConstraintsWithFormat(visualFormat: "V:[v0(70)]", views: replayButton)
        infoWrapper.addConstraintsWithFormat(visualFormat: "V:|-[v0(30)]-[v1]-[v2(5)]|", views: titleContent, infoLabel, progressBar)
        infoWrapper.addConstraintsWithFormat(visualFormat: "H:|-16-[v0]-[v1(70)]-16-|", views: titleContent, replayButton)
        infoWrapper.addConstraintsWithFormat(visualFormat: "H:|-16-[v0]-[v1]", views: infoLabel, replayButton)
        infoWrapper.addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: progressBar)
        infoWrapper.centerVerticalWithConstraints(replayButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
