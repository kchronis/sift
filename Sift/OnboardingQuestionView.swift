//
//  OnboardingQuestionView.swift
//  Sift
//
//  Created by Kyle Chronis on 2/25/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import UIKit

class OnboardingQuestionView: UIView {
    typealias ButtonAlignment = UILayoutConstraintAxis
    typealias SelectionHandler = (Int) -> Void
    typealias AnimationCompletionHandler = ((Bool) -> ())?
    
    //MARK: Properties
    static let animationDuration: TimeInterval = 0.42
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let buttonContainerView = UIView()
    var buttonContainerLeadingConstraint: NSLayoutConstraint!
    var buttons : Array<UIButton>!
    private let selectionHandler : SelectionHandler
    
    init(
        header: String,
        buttonTitles: [String],
        buttonAlignment: ButtonAlignment,
        selectionHandler: @escaping SelectionHandler) {
        
        self.selectionHandler = selectionHandler
        
        super.init(frame: CGRect.zero)
        // header
        self.headerLabel.text = header
        // buttons
        self.buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.buttons = self.createButtons(titles: buttonTitles)
        
        self.setupLayout(buttonAlignment: buttonAlignment)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateIn(completionHandler: AnimationCompletionHandler = nil) {
        self.buttonContainerLeadingConstraint.constant = -(self.frame.maxX - (self.frame.midX - self.buttonContainerView.frame.width/2))
        UIView.animate(
            withDuration: OnboardingQuestionView.animationDuration,
            animations: {
                self.headerLabel.alpha = 1
                self.layoutIfNeeded()
        }, completion: { (finished) in
            if let completion = completionHandler {
                completion(finished)
            }
        })
    }
    
    func animateOut(completionHandler: AnimationCompletionHandler = nil) {
        self.buttonContainerLeadingConstraint.constant = -(self.frame.maxX - (self.frame.minX - self.buttonContainerView.frame.width))
        UIView.animate(
            withDuration: OnboardingQuestionView.animationDuration,
            animations: {
                self.headerLabel.alpha = 0
                self.layoutIfNeeded()
        }, completion: { (finished) in
            if let completion = completionHandler {
                completion(finished)
            }
        })
    }
    
    func didSelect(sender: UIButton) {
        print("Button Index \(sender.tag)")
        self.selectionHandler(sender.tag)
    }
    
    private func createButtons(titles: [String]) -> Array<UIButton> {
        var buttons : Array = [UIButton]()
        for (index, title) in titles.enumerated() {
            let button = UIButton(type: UIButtonType.custom)
            button.titleLabel?.font = UIFont(name: "DINAlternate-Bold", size: 22)
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitle(title, for: .normal)
            button.tag = index
            button.setBackgroundColor(color: UIColor.blue, state: .normal)
            button.contentEdgeInsets = UIEdgeInsetsMake(10, 25, 10, 25)
            button.addTarget(
                self,
                action: #selector(didSelect(sender:)),
                for: .touchUpInside
            )
            button.translatesAutoresizingMaskIntoConstraints = false
            
            buttons.append(button)
        }
        return buttons
    }
    
    private func setupLayout(buttonAlignment: ButtonAlignment) {
        
        self.addSubview(self.headerLabel)
        self.addSubview(self.buttonContainerView)
        
        self.layoutButtons(alignment: buttonAlignment)
        
        // layout header and buttonContainer
        let topMargin = 60
        let headerLabelMargin = 30
        
        let views = ["headerLabel": self.headerLabel, "buttonContainerView": buttonContainerView]
        let metrics = ["topMargin": topMargin, "headerLabelMargin": headerLabelMargin]
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(topMargin)-[headerLabel]-(>=0)-[buttonContainerView]-(>=0)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metrics,
            views: views)
        )
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(headerLabelMargin)-[headerLabel]-(headerLabelMargin)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metrics,
            views: views)
        )
        NSLayoutConstraint(
            item: self.headerLabel,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0).isActive = true
        NSLayoutConstraint(
            item: self.buttonContainerView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0).isActive = true
        
        // starts off screen
        self.buttonContainerLeadingConstraint = NSLayoutConstraint(
            item: self.buttonContainerView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0.0)
        self.buttonContainerLeadingConstraint.isActive = true
    }
    
    private func layoutButtons(alignment: ButtonAlignment) {
        let stackView = UIStackView(arrangedSubviews: self.buttons)
        stackView.axis = alignment
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.buttonContainerView.addSubview(stackView)
        let horizontalMargin: CGFloat = 40.0
        stackView.topAnchor.constraint(
            equalTo: self.buttonContainerView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(
            equalTo: self.buttonContainerView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(
            equalTo: self.buttonContainerView.leadingAnchor,
            constant: horizontalMargin).isActive = true
        stackView.trailingAnchor.constraint(
            equalTo: self.buttonContainerView.trailingAnchor,
            constant: -horizontalMargin).isActive = true
    }
}
