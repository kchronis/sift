
//
//  TweetMetricsView.swift
//  Sift
//
//  Created by Kyle Chronis on 7/24/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import UIKit

class TweetMetricsView : UIView {
    let retweetIconImageView : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "retweet_icon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let retweetCountLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let favoriteIconImageView : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "favorite_icon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let favoriteCountLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
    }
    
    func setMetrics(retweetCount: Int, favoriteCount: Int) {
        self.retweetCountLabel.text = "\(retweetCount)"
        self.favoriteCountLabel.text = "\(favoriteCount)"
    }
    
    private func setupLayout() {
        self.addSubview(retweetIconImageView)
        self.addSubview(retweetCountLabel)
        self.addSubview(favoriteIconImageView)
        self.addSubview(favoriteCountLabel)
        
        let imageSize: CGFloat = 16.0
        let horizontalPadding: CGFloat = 25.0
        
        let views = [
            "retweetIconImageView": retweetIconImageView,
            "retweetCountLabel": retweetCountLabel,
            "favoriteIconImageView": favoriteIconImageView,
            "favoriteCountLabel": favoriteCountLabel
        ]
        let metrics = [
            "horizontalPadding": horizontalPadding,
            "imageSize": imageSize
        ]
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[retweetIconImageView(imageSize)]-[retweetCountLabel]-(horizontalPadding)-[favoriteIconImageView(imageSize)]-[favoriteCountLabel]-(>=0)-|",
            options: .alignAllCenterY,
            metrics: metrics,
            views: views)
        )
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[retweetIconImageView(imageSize)]|",
            options: .alignAllCenterY,
            metrics: metrics,
            views: views)
        )
    }
}
