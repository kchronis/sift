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
import MessageUI

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate {
    let tableView: UITableView = UITableView()
    let loadingWindow: TimelineLoadingWindow = {
        let loadingWindow = TimelineLoadingWindow()
        UIApplication.shared.keyWindow?.addSubview(loadingWindow)
        return loadingWindow
    }()
    let viewModel: TimelineViewModel
    var lastViewedTweet: Tweet?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(handleRefresh(refreshControl:)),
            for: .valueChanged
        )
        return refreshControl
    }()
    
    init(viewModel: TimelineViewModel) {
        self.viewModel = viewModel
        super.init(nibName:nil, bundle:nil)
        self.registerOberservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let footerView = TimelineFooterView(selectionHandler: { [unowned self] in
            self.sendShareSMS()
        })
        footerView.backgroundColor = UIColor(red: 70/255, green: 154/255, blue: 233/255, alpha: 1)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        // use container to set the size of the table footer
        let tableFooterViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 80))
        self.tableView.tableFooterView = tableFooterViewContainer
        self.tableView.allowsSelection = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(
            TimelineTableViewCell.self,
            forCellReuseIdentifier: TimelineTableViewCell.reuseIdentifier
        )
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableFooterViewContainer.addSubview(footerView)
        self.tableView.addSubview(self.refreshControl)
        self.view.addSubview(self.tableView)
        
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        footerView.topAnchor.constraint(equalTo: tableFooterViewContainer.topAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: tableFooterViewContainer.bottomAnchor).isActive = true
        footerView.leadingAnchor.constraint(equalTo: tableFooterViewContainer.leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: tableFooterViewContainer.trailingAnchor).isActive = true
        
        // MARK: Temporary
        let reset = UIBarButtonItem(
            title: "Reset Filters",
            style: .plain,
            target: self,
            action: #selector(resetFilter)
        )
        self.navigationItem.leftBarButtonItem = reset
        
        self.getTimeLine()
    }
    
    func reloadView() {
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
        self.view.layoutIfNeeded()
        // Temp HACK(KC) need to handle error cases (no tweets)
        if  self.viewModel.tweets.count > 0 {
            self.tableView.scrollToRow(
                at: self.viewModel.lastViewedIndexPath(),
                at: .top,
                animated: false
            )
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.getTimeLine()
    }
    
    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.rowCount()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TimelineTableViewCell.reuseIdentifier) as! TimelineTableViewCell
        cell.resetCell(tweet: self.viewModel.tweet(for: indexPath))
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
            self.viewModel.setLastViewedIndexPath(indexPath: indexPath)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Track last viewed cell after reload is comeplete
        // or should we just mark the center cell as viewed?
        //        if let indexPath = self.tableView.indexPathsForVisibleRows?.first {
        //            print("indexpath \(indexPath)")
        //            let cellRect = self.tableView.rectForRow(at: indexPath)
        //            let completelyVisible = self.tableView.bounds.contains(cellRect)
        //            self.viewModel.setLastViewedIndexPath(indexPath: indexPath)
        //        }
    }
    
    func resetFilter() {
        self.dismiss(
            animated: false,
            completion: nil
        )
    }
    func getTimeLine() {
        self.loadingWindow.present()
        self.viewModel.getTimeline { [unowned self] (filterResults: String) in
            self.reloadView()
            self.loadingWindow.beginDismissalAnimation(loadingText: filterResults) {
                print("finished dismissal")
            }
        }
    }
    
    func didEnterBackground(notification: Notification) {
        self.loadingWindow.present()
        self.viewModel.account.saveAccount()
    }
    
    func willEnterForeground(notification: Notification) {
        self.getTimeLine()
    }
    
    private func sendShareSMS() {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Check out this app <app store link>"
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func registerOberservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground(notification:)),
            name: .UIApplicationDidEnterBackground,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground(notification:)),
            name: .UIApplicationWillEnterForeground,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

