//
//  TweetTableViewCell.swift
//  Sift
//
//  Created by Kyle Chronis on 2/25/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import UIKit
import SDWebImage

class TweetTableViewCell: UITableViewCell {
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let usernameLabel = UILabel()
    let tweetedAtLabel = UILabel()
    let bodyLabel = UILabel()
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.backgroundColor = UIColor.gray
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        tweetedAtLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        tweetedAtLabel.textColor = UIColor.gray
        tweetedAtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bodyLabel.numberOfLines = 0
        bodyLabel.font = UIFont(name: "HelveticaNeue", size: 15)
        bodyLabel.textColor = UIColor.gray
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(usernameLabel)
        self.contentView.addSubview(tweetedAtLabel)
        self.contentView.addSubview(bodyLabel)
        
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func resetCell(tweet: Tweet) {
        self.nameLabel.text = tweet.user.name
        self.usernameLabel.text = tweet.user.userName
        self.tweetedAtLabel.text = tweet.formattedTweetedAt()
        self.bodyLabel.text = tweet.text
        self.profileImageView.sd_setImage(with: tweet.user.profileImageURL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupConstraints() {
        let imageSize = 48.0
        let horizontalPadding = 8.0
        let verticalPadding = 10.0
        let views = [
            "profileImageView": profileImageView,
            "nameLabel": nameLabel,
            "usernameLabel": usernameLabel,
            "tweetedAtLabel": tweetedAtLabel,
            "bodyLabel": bodyLabel
        ]
        let metrics = ["imageSize": imageSize, "horizontalPadding": horizontalPadding, "verticalPadding": verticalPadding]
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(verticalPadding)-[nameLabel]-(4)-[bodyLabel]-(verticalPadding)-|",
            options: .alignAllLeading,
            metrics: metrics,
            views: views)
        )
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(horizontalPadding)-[profileImageView(imageSize)]-(horizontalPadding)-[nameLabel]-(horizontalPadding)-[usernameLabel]-(>=horizontalPadding)-[tweetedAtLabel]-(horizontalPadding)-|",
            options: .alignAllTop,
            metrics: metrics,
            views: views)
        )
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[bodyLabel]-(horizontalPadding)-|",
            options: .alignAllLeading,
            metrics: metrics,
            views: views)
        )
        self.contentView.addConstraint(NSLayoutConstraint(
            item: profileImageView,
            attribute: .width,
            relatedBy: .equal,
            toItem: profileImageView,
            attribute: .height,
            multiplier: 1.0,
            constant: 0.0)
        )
    }

}
