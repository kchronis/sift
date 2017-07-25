//
//  TweetContentView.swift
//  Sift
//
//  Created by Kyle Chronis on 3/1/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import UIKit

class TweetContentView: UIView {
    let nameLabel = UILabel()
    let usernameLabel = UILabel()
    let bodyLabel = UILabel()
    var tweet : Tweet? {
        didSet {
            self.nameLabel.text = tweet?.user.name
            self.usernameLabel.text = tweet?.user.userName
            self.bodyLabel.text = tweet?.text
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        nameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        nameLabel.textColor = UIColor.black
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        usernameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        usernameLabel.textColor = UIColor.gray
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.minimumScaleFactor = 0.8
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bodyLabel.numberOfLines = 0
        bodyLabel.font = UIFont(name: "HelveticaNeue", size: 15)
        bodyLabel.textColor = UIColor.gray
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(nameLabel)
        self.addSubview(usernameLabel)
        self.addSubview(bodyLabel)
        
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
    }
    
    private func setupConstraints() {
        let imageSize = 48.0
        let horizontalPadding = 8.0
        let optionalConstraints = 500.0
        let views = [
            "nameLabel": nameLabel,
            "usernameLabel": usernameLabel,
            "bodyLabel": bodyLabel
        ]
        let metrics = [
            "imageSize": imageSize,
            "horizontalPadding": horizontalPadding,
            "optionalConstraints": optionalConstraints
        ]
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[nameLabel]-(4@optionalConstraints)-[bodyLabel]|",
            options: .alignAllLeading,
            metrics: metrics,
            views: views)
        )
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[nameLabel]-(horizontalPadding)-[usernameLabel]-(>=0)-|",
            options: .alignAllTop,
            metrics: metrics,
            views: views)
        )
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[bodyLabel]-(horizontalPadding)-|",
            options: .alignAllLeading,
            metrics: metrics,
            views: views)
        )
    }
}
