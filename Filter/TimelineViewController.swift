//
//  TimelineViewController.swift
//  Sift
//
//  Created by Kyle Chronis on 2/20/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import UIKit
import Social
import Accounts
import SwiftyJSON

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let timelineURL = URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
    let tableView : UITableView = UITableView()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(handleRefresh(refreshControl:)),
            for: .valueChanged
        )
        return refreshControl
    }()
    var tweets = [Tweet]()
    
    init() {
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(TweetTableViewCell.self,
                                forCellReuseIdentifier: "TweetCell")
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.addSubview(self.refreshControl)
        self.view.addSubview(self.tableView)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[tableView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["tableView": self.tableView]
            )
        )
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[tableView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["tableView": self.tableView]
            )
        )
        
        self.getTimeLine()
        
    }
    
    
    func reloadView() {
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        self.view.layoutIfNeeded()
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        self.getTimeLine()
       // refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetTableViewCell
        let row = indexPath.row
        let tweet : Tweet = self.tweets[row]
        cell.resetCell(tweet: tweet)
        return cell
    }
    
    
    // MARK: Temporary
    
    func getTimeLine() {
        
        let account = ACAccountStore()
        let accountType = account.accountType(
            withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        
        account.requestAccessToAccounts(with: accountType, options: nil, completion: {(success, error) in
            
            if success {
                let arrayOfAccounts =
                    account.accounts(with: accountType)
                
                if (arrayOfAccounts?.count)! > 0 {
                    let twitterAccount = arrayOfAccounts?.last as! ACAccount
                    
                    let parameters = ["include_rts" : "1",
                                      "trim_user" : "0",
                                      "count" : "100"]
                    
                    let postRequest = SLRequest(
                        forServiceType: SLServiceTypeTwitter,
                        requestMethod: SLRequestMethod.GET,
                        url: self.timelineURL,
                        parameters: parameters
                    )
                    
                    postRequest?.account = twitterAccount
                    
                    postRequest?.perform(handler: {(responseData, urlResponse, error) in
                        let json = JSON(data: responseData!)
                        if json.count > 0 {
                            print("TWEETS \(json)")
                            self.tweets = json.arrayValue.map { Tweet(tweetDictionary: $0.dictionaryObject!)}
                        }
                        DispatchQueue.main.async() {
                            self.reloadView()
                        }
                    })
                }
            } else {
                print("Failed to access account")
            }
        })
    }
    
}

