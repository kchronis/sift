//
//  TimelineLoadingWindow.swift
//  Sift
//
//  Created by Kyle Chronis on 7/18/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import UIKit

class TimelineLoadingWindow: UIWindow {
    typealias CompletionHandler = (Void) -> Void
    let iconImageView: UIImageView = {
        let image = UIImage(named: "twitter_logo_blue")
        let imageView = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let loadingLabel: UILabel = {
        let loadingLabel = UILabel()
        loadingLabel.text = "Retrieving tweets..." // default value
        loadingLabel.textColor = UIColor.white
        loadingLabel.textAlignment = .center
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        return loadingLabel
    }()
    
    // MARK: Initialization
    init() {
        super.init(frame: UIScreen.main.bounds)
        self.windowLevel = UIWindowLevelStatusBar
        self.isHidden = true
        self.backgroundColor = UIColor(red: 70/255, green: 154/255, blue: 233/255, alpha: 1)
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    func present() {
        self.isHidden = false
    }
    
    func beginDismissalAnimation(loadingText: String, completionHander: @escaping CompletionHandler) {
        self.loadingLabel.text = loadingText
        UIView.animate(
            withDuration: 0.22,
            delay: 0.75,
            options: .curveEaseInOut,
            animations: {
                let scaleTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                self.iconImageView.transform = scaleTransform
        }) { (finished) in
            UIView.animate(withDuration: 0.3, animations: {
                let scaleTransform: CGAffineTransform = CGAffineTransform(scaleX: 20, y: 20)
                self.iconImageView.transform = scaleTransform
                self.alpha = 0
            }, completion: { [unowned self] (finished) in
                self.removeFromSuperview()
                completionHander()
            })
        }
    }
    
    // MARK: Private
    private func setupLayout() {
        self.addSubview(self.iconImageView)
        self.addSubview(self.loadingLabel)
        
        // constraints
        let imageSize: CGFloat = 90.0
        let loadingLabelTopPadding: CGFloat = 40.0
        let views = ["iconImageView": self.iconImageView, "loadingLabel": self.loadingLabel]
        let metrics = ["imageSize": imageSize, "loadingLabelTopPadding": loadingLabelTopPadding]
        
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[iconImageView(imageSize)]-(loadingLabelTopPadding)-[loadingLabel]",
                options: .alignAllCenterX,
                metrics: metrics,
                views: views
            )
        )
        self.addConstraint(
            NSLayoutConstraint(
                item: self.iconImageView,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: imageSize
            )
        )
        
        self.iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
}
