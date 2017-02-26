//
//  TimelineViewController.swift
//  Filter
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
    var tweets = [Any]()
    
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
        self.tableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: "Cell")
        self.tableView.estimatedRowHeight = 50
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        
        getTimeLine()
    }
    
    
    func reloadView() {
        self.tableView.reloadData()
        self.view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let row = indexPath.row
        let tweet = self.tweets[row]
        cell!.textLabel!.text = (tweet as AnyObject).object(forKey: "text") as? String
        cell!.textLabel!.numberOfLines = 0
        return cell!
    }
    
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
                    // need to implement since_id, count (max is 200)
                    let parameters = ["include_rts" : "1",
                                      "trim_user" : "0", 
                                      "count" : "20"]
                    
                    let postRequest = SLRequest(forServiceType:
                        SLServiceTypeTwitter,
                                                requestMethod: SLRequestMethod.GET,
                                                url: self.timelineURL!,
                                                parameters: parameters)
                    
                    postRequest?.account = twitterAccount
                    
                    postRequest?.perform(handler: {(responseData, urlResponse, error) in
                        
                        let json = JSON(data: responseData!)
                        if json.count > 0 {
                            self.tweets = json.arrayObject!
                            print("TWEETS \(json)")
                            if self.tweets.count != 0 {
                                DispatchQueue.main.async() {
                                    self.reloadView()
                                }
                            }
                        }
//                        do {
//                            try self.tweets = JSONSerialization.jsonObject(with: responseData!,
//                                                                               options: JSONSerialization.ReadingOptions.mutableLeaves) as! [AnyObject]
//                            
//                            print("TWEETS \(self.tweets)")
//                            if self.tweets.count != 0 {
//                                DispatchQueue.main.async() {
//                                    self.reloadView()
//                                }
//                            }
//                        } catch let error as NSError {
//                            print("Data serialization error: \(error.localizedDescription)")
//                        }
                    })
                }
                else {
                    print("No Linked Accounts")
                }
            } else {
                print("Failed to access account")
            }
        })
    }
}

