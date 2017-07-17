//
//  TimelineFooterView.swift
//  Sift
//
//  Created by Kyle Chronis on 7/17/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import UIKit

class TimelineFooterView : UIView {
    typealias SelectionHandler = (Void) -> Void
    
    let headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = "Are you enjoying the app?"
        headerLabel.numberOfLines = 0
        headerLabel.textAlignment = .center
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()
    let referButton: UIButton = {
        let referButton = UIButton(type: .system)
        referButton.setTitle("Share", for: .normal)
        referButton.addTarget(
            self,
            action: #selector(didSelect(sender:)),
            for: .touchUpInside
        )
        referButton.translatesAutoresizingMaskIntoConstraints = false
        return referButton
    }()
    private let selectionHandler: SelectionHandler
    
    init(selectionHandler: @escaping SelectionHandler) {
        self.selectionHandler = selectionHandler
        
        super.init(frame: CGRect.zero)
        
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didSelect(sender: UIButton) {
        self.selectionHandler()
    }
    
    private func setupLayout() {
        let centerLayoutGuide = UILayoutGuide()
        // add elements to view
        self.addLayoutGuide(centerLayoutGuide)
        self.addSubview(self.headerLabel)
        self.addSubview(self.referButton)
        
        let margins = self.layoutMarginsGuide
        // set center layout guide
        centerLayoutGuide.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        centerLayoutGuide.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        centerLayoutGuide.leadingAnchor.constraint(lessThanOrEqualTo: margins.leadingAnchor).isActive = true
        centerLayoutGuide.trailingAnchor.constraint(lessThanOrEqualTo: margins.trailingAnchor).isActive = true
        // set label and button
        centerLayoutGuide.topAnchor.constraint(equalTo: headerLabel.topAnchor).isActive = true
        centerLayoutGuide.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor).isActive = true
        centerLayoutGuide.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor).isActive = true
        referButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 2.0).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: centerLayoutGuide.centerXAnchor).isActive = true
        centerLayoutGuide.bottomAnchor.constraint(equalTo: referButton.bottomAnchor).isActive = true
        referButton.centerXAnchor.constraint(equalTo: centerLayoutGuide.centerXAnchor).isActive = true
    }
}
