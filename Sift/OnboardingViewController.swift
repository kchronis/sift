//
//  OnboardingViewController.swift
//  Sift
//
//  Created by Kyle Chronis on 2/25/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    let onboardingView : OnboardingView = OnboardingView()

    init() {
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.onboardingView.backgroundColor = UIColor.white
        self.onboardingView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(onboardingView)
        
        self.view.addConstraint(NSLayoutConstraint.init(item: self.onboardingView,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: self.view,
                                                   attribute: .centerY,
                                                   multiplier: 1.0,
                                                   constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.onboardingView,
                                                        attribute: .centerX,
                                                        relatedBy: .equal,
                                                        toItem: self.view,
                                                        attribute: .centerX,
                                                        multiplier: 1.0,
                                                        constant: 0.0))
        //let views = ["onboardingView": self.onboardingView]
//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[onboardingView]|",
//                                                                options: NSLayoutFormatOptions(rawValue: 0),
//                                                                metrics: nil,
//                                                                views: views))
//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[onboardingView]|",
//                                                                options: NSLayoutFormatOptions(rawValue: 0),
//                                                                metrics: nil,
//                                                                views: views))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
