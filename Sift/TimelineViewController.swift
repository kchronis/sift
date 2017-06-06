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
    let account : Account
    let tableView : UITableView = UITableView()
    var lastViewedTweet : Tweet?
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
    
    init(account: Account) {
        self.account = account
        super.init(nibName:nil, bundle:nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground(notification:)),
            name: .UIApplicationDidEnterBackground,
            object: nil
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
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
        self.tableView.scrollToRow(at: self.lastViewIndexPath(), at: .top, animated: true)
        
        // should be scroll to last read
        //self.scrollToBottom()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.getTimeLine()
    }
    
    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetTableViewCell
        let row = indexPath.row
        let tweet : Tweet = self.tweets[row]
        cell.resetCell(tweet: tweet)
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        // should be in scrolling delegate
       // self.account.lastViewedTweetId = self.tweets[indexPath.row].id
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = self.tableView.indexPathsForVisibleRows?.first {
            print("indexpath \(indexPath)")
            self.account.lastViewedTweetId = self.tweets[indexPath.row].id
        }
    }
    
    func getTimeLine() {
        TimelineService.getTimeLine(
        account: self.account) { (result : TimelineServiceResult<Array<Tweet>>) in
            switch result  {
            case .success(let tweets):
                // should be appending
                let filterResults = FilterService.execute(account: self.account, tweets: tweets)
                self.tweets += filterResults.filteredTweets
                print("REMOVED \(filterResults.removedCount)")
                self.reloadView()
            case .failure(let error):
                print("ERROR \(error)")
            }
        }
    }
    
    func didEnterBackground(notification: Notification) {
        print("DID ENTER BACKGROUND")
        self.account.saveAccount()
    }
    
    private func scrollToBottom() {
        let indexPath = IndexPath(row: self.tweets.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func lastViewIndexPath() -> IndexPath {
        if let lastViewedId = self.account.lastViewedTweetId,
            let index =  self.tweets.index(where: { $0.id == lastViewedId }) {
            return IndexPath(row: index, section: 0)
        }
        else {
            return IndexPath(row: (self.tweets.count - 1), section: 0)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

