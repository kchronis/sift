//
//  LoginViewController.swift
//  Sift
//
//  Created by Kyle Chronis on 3/8/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import UIKit
import Accounts

class LoginViewController: UIViewController {
    let logoImageView : UIImageView = UIImageView()
    let signInButton : UIButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.signInButton.setTitle("SIGN IN WITH TWITTER", for: .normal)
        self.signInButton.setBackgroundColor(color: UIColor.blue, state: .normal)
        self.signInButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        self.signInButton.addTarget(self, action: #selector(didSelectLogin(sender:)), for: .touchUpInside)
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.signInButton)
        
        self.setupConstraints()
    }
    
    func didSelectLogin(sender: UIButton) {
        sender.isEnabled = false
        AccountService.getAccounts { (result : AccountServiceResult<Array<ACAccount>>) in
            switch result {
            case .success(let accounts):
                print("ACCOUNTS \(accounts)")
                self.presentActionSheet(accounts: accounts)
            case .failure(let error):
                self.handle(error: error)
            }
            sender.isEnabled = true
        }
    }
    
    private func setupConstraints() {
        let buttonPadding = 20
        
        let views = [
            "logoImageView": self.logoImageView,
            "signInButton": self.signInButton
        ]
        let metrics = ["buttonPadding": buttonPadding]
        
        self.view.addConstraint(NSLayoutConstraint(
            item: self.logoImageView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0)
        )
        self.view.addConstraint(NSLayoutConstraint(
            item: self.logoImageView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0)
        )
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[signInButton]-(buttonPadding)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metrics,
            views: views)
        )
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(buttonPadding)-[signInButton]-(buttonPadding)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metrics,
            views: views)
        )
    }
    
    private func presentActionSheet(accounts: Array<ACAccount>) {
        let actionSheetAlert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        for (index, account) in accounts.enumerated() {
            let action = UIAlertAction(
                title: ("@" + account.username),
                style: .default
            ) { (alert: UIAlertAction!) -> Void in
                self.didSelectAccount(twitterAccount: accounts[index])
            }
            actionSheetAlert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .destructive
        ) { action in
            self.dismiss(animated: true, completion: nil)
        }
        actionSheetAlert.addAction(cancelAction)
        self.present(actionSheetAlert, animated: true, completion: nil)
    }
    
    private func didSelectAccount(twitterAccount: ACAccount) {
        let account = Account(twitterAccount: twitterAccount)
        account.saveAccount()
        
        //TODO:(KC) Should we check if they have already been through the onboarding flow?
        let onboardingViewController = OnboardingViewController(
            viewModel: OnboardingViewModel(account: account)
        )
        self.navigationController?.pushViewController(
            onboardingViewController,
            animated: true
        )
    }
    
    private func handle(error: AccountServiceError) {
        let alert = UIAlertController(
            title: error.title(),
            message: error.description(),
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: "Ok",
            style: .cancel
        ) { action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
