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
    static let reuseIdentifier = "\(TweetTableViewCell.self)"
    let profileImageView = UIImageView()
    let tweetContentView = UIView()
    let nameLabel = UILabel()
    let usernameLabel = UILabel()
    let tweetedAtLabel = UILabel()
    let bodyLabel = UILabel()
    let actionLabel = UILabel()
    let quotedTweetView = QuotedTweetView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.backgroundColor = UIColor.gray
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        tweetContentView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        nameLabel.textColor = UIColor.black
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
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
        
        // conditional views
        actionLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        actionLabel.textColor = UIColor.gray
        actionLabel.adjustsFontSizeToFitWidth = true
        actionLabel.minimumScaleFactor = 0.8
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        quotedTweetView.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        quotedTweetView.layer.borderWidth = 1
        quotedTweetView.layer.cornerRadius = 4
        quotedTweetView.layer.masksToBounds = true
        quotedTweetView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tweetContentView.addSubview(profileImageView)
        self.tweetContentView.addSubview(nameLabel)
        self.tweetContentView.addSubview(usernameLabel)
        self.tweetContentView.addSubview(tweetedAtLabel)
        self.tweetContentView.addSubview(bodyLabel)
        
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func resetCell(tweet: Tweet) {
        if let quotedTweet = tweet.quotedTweet {
            self.quotedTweetView.isHidden = false
            self.quotedTweetView.tweet = quotedTweet
        }
        else {
            self.quotedTweetView.isHidden = true
        }
        
        if let retweetedTweet = tweet.retweetedTweet {
            self.setContent(tweet: retweetedTweet)
            self.actionLabel.text = "\(tweet.user.name) Retweeted"
            self.actionLabel.isHidden = false
        }
        else {
            self.setContent(tweet: tweet)
            self.actionLabel.isHidden = true
        }
    }

    private func setContent(tweet: Tweet) {
        self.nameLabel.text = tweet.user.name
        self.usernameLabel.text = tweet.user.userName
        self.tweetedAtLabel.text = tweet.formattedTweetedAt()
        self.bodyLabel.text = tweet.text
        self.profileImageView.sd_setImage(with: tweet.user.profileImageURL)
    }
    
    private func setupConstraints() {
        let imageSize : CGFloat = 48.0
        let horizontalPadding : CGFloat = 8.0
        let verticalPadding : CGFloat = 10.0
        let optionalConstraintPriority : CGFloat = 800.0
        let views = [
            "profileImageView": profileImageView,
            "actionLabel": actionLabel,
            "nameLabel": nameLabel,
            "usernameLabel": usernameLabel,
            "tweetedAtLabel": tweetedAtLabel,
            "bodyLabel": bodyLabel
        ]
        let metrics = [
            "imageSize": imageSize,
            "horizontalPadding": horizontalPadding,
            "verticalPadding": verticalPadding,
            "optionalPriority": optionalConstraintPriority
        ]
        
        self.tweetContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[nameLabel]-(4)-[bodyLabel]-(0@500)-|",
            options: .alignAllLeading,
            metrics: metrics,
            views: views)
        )
        self.tweetContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[profileImageView(imageSize)]",
            options: .alignAllLeading,
            metrics: metrics,
            views: views)
        )
        self.tweetContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[profileImageView(imageSize)]-(horizontalPadding)-[nameLabel]-(horizontalPadding)-[usernameLabel]-(>=horizontalPadding)-[tweetedAtLabel]|",
            options: .alignAllTop,
            metrics: metrics,
            views: views)
        )
        self.tweetContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[bodyLabel]-(horizontalPadding)-|",
            options: .alignAllLeading,
            metrics: metrics,
            views: views)
        )
        self.tweetContentView.addConstraint(NSLayoutConstraint(
            item: self.bodyLabel,
            attribute: .bottom,
            relatedBy: .greaterThanOrEqual,
            toItem: self.profileImageView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0)
        )
        let stackView = UIStackView(arrangedSubviews: [self.actionLabel, self.tweetContentView, self.quotedTweetView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .trailing
        stackView.spacing = verticalPadding
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(stackView)
        stackView.addConstraint(NSLayoutConstraint(
            item: self.tweetContentView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: stackView,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0.0)
        )
        stackView.addConstraint(NSLayoutConstraint(
            item: self.quotedTweetView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: stackView,
            attribute: .leading,
            multiplier: 1.0,
            constant: 56.0)
        )
        stackView.addConstraint(NSLayoutConstraint(
            item: self.actionLabel,
            attribute: .leading,
            relatedBy: .equal,
            toItem: stackView,
            attribute: .leading,
            multiplier: 1.0,
            constant: 56.0)
        )
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(verticalPadding)-[stackView]-(verticalPadding)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metrics,
            views: ["stackView": stackView])
        )
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(horizontalPadding)-[stackView]-(horizontalPadding)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metrics,
            views: ["stackView": stackView])
        )
    }
}
