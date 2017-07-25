//
//  TimelineTableViewCell.swift
//  Sift
//
//  Created by Kyle Chronis on 2/25/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import UIKit
import SDWebImage

class TimelineTableViewCell: UITableViewCell {
    static let reuseIdentifier = "\(TimelineTableViewCell.self)"
    let profileImageView = UIImageView()
    let tweetedAtLabel = UILabel()
    let actionLabel = UILabel()
    let tweetContentView = TweetContentView()
    let quotedTweetContentView = TweetContentView()
    let tweetMetricsView = TweetMetricsView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.backgroundColor = UIColor.gray
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        tweetedAtLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        tweetedAtLabel.textColor = UIColor.gray
        tweetedAtLabel.setContentCompressionResistancePriority(
            UILayoutPriorityRequired, for: .horizontal
        )
        tweetedAtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // conditional views
        actionLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        actionLabel.textColor = UIColor.gray
        actionLabel.adjustsFontSizeToFitWidth = true
        actionLabel.minimumScaleFactor = 0.8
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tweetContentView.translatesAutoresizingMaskIntoConstraints = false
        
        quotedTweetContentView.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        quotedTweetContentView.layer.borderWidth = 1
        quotedTweetContentView.layer.cornerRadius = 4
        quotedTweetContentView.layer.masksToBounds = true
        quotedTweetContentView.translatesAutoresizingMaskIntoConstraints = false
        
        tweetMetricsView.translatesAutoresizingMaskIntoConstraints = false
        
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func resetCell(tweet: Tweet) {
        if let quotedTweet = tweet.quotedTweet {
            self.quotedTweetContentView.isHidden = false
            self.quotedTweetContentView.tweet = quotedTweet
        }
        else {
            self.quotedTweetContentView.isHidden = true
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
        self.tweetedAtLabel.text = tweet.formattedTweetedAt()
        self.profileImageView.sd_setImage(with: tweet.user.profileImageURL)
        self.tweetContentView.tweet = tweet
        self.tweetMetricsView.setMetrics(
            retweetCount: tweet.retweetCount,
            favoriteCount: tweet.favoriteCount
        )
    }
    
    private func setupLayout() {
        // layout constants
        let imageSize : CGFloat = 48.0
        let horizontalPadding : CGFloat = 8.0
        let verticalPadding : CGFloat = 8.0
        
        // set view hierarchy
        let stackView = UIStackView(arrangedSubviews: [
            actionLabel,
            tweetContentView,
            quotedTweetContentView,
            tweetMetricsView]
        )
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = verticalPadding
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(tweetedAtLabel)
        self.contentView.addSubview(stackView)
        
        // set constraints
        let views = [
            "profileImageView": profileImageView,
            "tweetedAtLabel": tweetedAtLabel,
            "stackView": stackView
        ]
        let metrics = [
            "imageSize": imageSize,
            "horizontalPadding": horizontalPadding,
            "verticalPadding": verticalPadding
        ]
        // profileImageView
        self.contentView.addConstraint(NSLayoutConstraint(
            item: profileImageView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: imageSize)
        )
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(horizontalPadding)-[profileImageView(imageSize)]-(horizontalPadding)-[stackView]-(horizontalPadding)-[tweetedAtLabel]-(horizontalPadding)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metrics,
            views: views)
        )
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(verticalPadding)-[stackView]-(verticalPadding)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metrics,
            views: views)
        )
        
        profileImageView.topAnchor.constraint(equalTo: tweetContentView.topAnchor).isActive = true
        tweetedAtLabel.topAnchor.constraint(equalTo: tweetContentView.topAnchor).isActive = true
    }
}
