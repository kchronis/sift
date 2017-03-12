//
//  OnboardingView.swift
//  Sift
//
//  Created by Kyle Chronis on 2/25/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import UIKit

class OnboardingView: UIView {
    let headerLabel = UILabel()
    let buttonContainerView = UIView()
    var buttons : Array<UIButton>!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        self.headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.buttons = self.createButtons(number: 4)
        self.setupInitialState()
        self.buttonContainerView.addConstraints(self.setupFirstQuestion())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
    }
    
    func setupInitialState() {
        
        self.addSubview(self.headerLabel)
        self.addSubview(self.buttonContainerView)
        
        let views = ["headerLabel": self.headerLabel, "buttonContainerView": buttonContainerView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[headerLabel]-(10)-[buttonContainerView]|",
                                                           options: .alignAllCenterX,
                                                           metrics: nil,
                                                           views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0)-[headerLabel]-(>=0)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0)-[buttonContainerView]-(>=0)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: views))
        self.addConstraint(NSLayoutConstraint.init(item: self.buttonContainerView,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerX,
                                                   multiplier: 1.0,
                                                   constant: 0.0))
        
    }
    
    func setupFirstQuestion() -> Array<NSLayoutConstraint> {
        self.headerLabel.text = "Need a break from politics?"
        
        let noButton = self.buttons[0]
        noButton.setTitle("NO", for: .normal)
        noButton.addTarget(
            self,
            action: #selector(didSelectNo(sender:)),
            for: .touchUpInside
        )
        
        let yesButton = self.buttons[1]
        yesButton.setTitle("YES", for: .normal)
        yesButton.addTarget(
            self,
            action: #selector(didSelectYes(sender:)),
            for: .touchUpInside
        )
        
        
        self.buttonContainerView.addSubview(yesButton)
        self.buttonContainerView.addSubview(noButton)
        
        var layoutConstraints = [NSLayoutConstraint]()
        let views = ["yesButton": yesButton, "noButton": noButton]
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[yesButton]|",
                                                                            options: NSLayoutFormatOptions(rawValue: 0),
                                                                            metrics: nil,
                                                                            views: views))
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[noButton]|",
                                                                            options: NSLayoutFormatOptions(rawValue: 0),
                                                                            metrics: nil,
                                                                            views: views))
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[noButton]-(25)-[yesButton]|",
                                                                            options: NSLayoutFormatOptions(rawValue: 0),
                                                                            metrics: nil,
                                                                            views: views))
        return layoutConstraints
    }
    
    func setupSecondQuestion() -> Array<NSLayoutConstraint> {
        let justTrumpButton = self.buttons[0]
        justTrumpButton.setTitle("JUST TRUMP", for: .normal)
        justTrumpButton.addTarget(
            self,
            action: #selector(didSelectJustTrump(sender:)),
            for: .touchUpInside
        )
        
        let allPoliticsButton = self.buttons[1]
        allPoliticsButton.setTitle("ALL POLITICS", for: .normal)
        allPoliticsButton.addTarget(
            self,
            action: #selector(didSelectAllPolitics(sender:)),
            for: .touchUpInside
        )
        
        
        self.buttonContainerView.addSubview(allPoliticsButton)
        self.buttonContainerView.addSubview(justTrumpButton)
        
        var layoutConstraints = [NSLayoutConstraint]()
        let views = ["allPoliticsButton": allPoliticsButton, "justTrumpButton": justTrumpButton]
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[allPoliticsButton]|",
                                                                            options: NSLayoutFormatOptions(rawValue: 0),
                                                                            metrics: nil,
                                                                            views: views))
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[justTrumpButton]|",
                                                                            options: NSLayoutFormatOptions(rawValue: 0),
                                                                            metrics: nil,
                                                                            views: views))
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[justTrumpButton]-(25)-[allPoliticsButton]|",
                                                                            options: NSLayoutFormatOptions(rawValue: 0),
                                                                            metrics: nil,
                                                                            views: views))
        
        return layoutConstraints
    }
    
    func setupThirdQuestion() -> Array<NSLayoutConstraint> {
        let morningButton = self.buttons[0]
        morningButton.setTitle("MORNING", for: .normal)
        morningButton.addTarget(
            self,
            action: #selector(didSelectMorning(sender:)),
            for: .touchUpInside
        )
        let afternoonButton = self.buttons[1]
        afternoonButton.setTitle("AFTERNOON", for: .normal)
        afternoonButton.addTarget(
            self,
            action: #selector(didSelectAfternoon(sender:)),
            for: .touchUpInside
        )
        let eveningButton = self.buttons[2]
        eveningButton.setTitle("EVENING", for: .normal)
        eveningButton.addTarget(
            self,
            action: #selector(didSelectEvening(sender:)),
            for: .touchUpInside
        )
        let allDayButton = self.buttons[3]
        allDayButton.setTitle("ALL DAY", for: .normal)
        allDayButton.addTarget(
            self,
            action: #selector(didSelectAllDay(sender:)),
            for: .touchUpInside
        )
        
        
        self.buttonContainerView.addSubview(morningButton)
        self.buttonContainerView.addSubview(afternoonButton)
        self.buttonContainerView.addSubview(eveningButton)
        self.buttonContainerView.addSubview(allDayButton)
        
        var layoutConstraints = [NSLayoutConstraint]()
        let views = ["morningButton": morningButton, "afternoonButton": afternoonButton, "eveningButton": eveningButton, "allDayButton": allDayButton]
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[morningButton]-(8)-[eveningButton]|",
                                                                            options: NSLayoutFormatOptions(rawValue: 0),
                                                                            metrics: nil,
                                                                            views: views))
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[afternoonButton]-(8)-[allDayButton]|",
                                                                            options: NSLayoutFormatOptions(rawValue: 0),
                                                                            metrics: nil,
                                                                            views: views))
        layoutConstraints.append(contentsOf:(NSLayoutConstraint.constraints(withVisualFormat: "H:|[morningButton]-(15)-[afternoonButton(==morningButton)]|",
                                                                            options: NSLayoutFormatOptions(rawValue: 0),
                                                                            metrics: nil,
                                                                            views: views)))
        layoutConstraints.append(contentsOf:(NSLayoutConstraint.constraints(withVisualFormat: "H:|[eveningButton(==morningButton)]-(15)-[allDayButton(==morningButton)]|",
                                                                            options: NSLayoutFormatOptions(rawValue: 0),
                                                                            metrics: nil,
                                                                            views: views)))
        
        return layoutConstraints
    }
    
    // MARK: UIControl Target - Actions
    func didSelectYes(sender: UIButton) {
        UIView.animate(withDuration: 0.15, animations: {
            self.buttons.forEach({ $0.titleLabel?.alpha = 0 })
            self.headerLabel.alpha = 0
        }) { (finished) in
            self.buttonContainerView.removeConstraints(self.buttonContainerView.constraints)
            self.buttonContainerView.addConstraints(self.setupSecondQuestion())
            UIView.animate(
                withDuration: 0.25,
                animations: {
                    self.layoutIfNeeded()
            }, completion: nil)
            UIView .animate(
                withDuration: 0.15,
                delay: 0.2,
                options: .curveEaseInOut,
                animations: {
                    self.buttons.forEach({ $0.titleLabel?.alpha = 1 })
            }, completion: nil)
        }
    }
    
    func didSelectNo(sender: UIButton) {
        print("NO")
    }
    
    func didSelectAllPolitics(sender: UIButton) {
        print("ALL POLITICS")
    }
    
    func didSelectJustTrump(sender: UIButton) {
        print("JUST TRUMP")
        UIView.animate(withDuration: 0.15, animations: {
            self.buttons.forEach({ $0.titleLabel?.alpha = 0 })
            self.headerLabel.alpha = 0
        }) { (finished) in
            self.buttonContainerView.removeConstraints(self.buttonContainerView.constraints)
            self.buttonContainerView.addConstraints(self.setupThirdQuestion())
            UIView.animate(
                withDuration: 0.25,
                animations: {
                    self.layoutIfNeeded()
            }, completion: nil)
            UIView .animate(
                withDuration: 0.15,
                delay: 0.2,
                options: .curveEaseInOut,
                animations: {
                    self.buttons.forEach({ $0.titleLabel?.alpha = 1 })
            }, completion: nil)
        }
    }
    
    func didSelectMorning(sender: UIButton) {
        print("Mornings")
    }
    
    func didSelectAfternoon(sender: UIButton) {
        print("Afternoon")
    }
    
    func didSelectEvening(sender: UIButton) {
        print("Evening")
    }
    
    func didSelectAllDay(sender: UIButton) {
        print("All Day")
    }
    
    private func createButtons(number: Int) -> Array<UIButton> {
        var buttons : Array = [UIButton]()
        for _ in 1...number {
            let button = UIButton(type: UIButtonType.custom)
            button.titleLabel?.font = UIFont(name: "DINAlternate-Bold", size: 22)
            button.setTitleColor(UIColor.blue, for: .normal)
            button.backgroundColor = UIColor.red
            button.contentEdgeInsets = UIEdgeInsetsMake(8, 15, 8, 15)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            buttons.append(button)
        }
        return buttons
    }
}
