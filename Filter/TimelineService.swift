//
//  TimelineService.swift
//  Sift
//
//  Created by Kyle Chronis on 2/21/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import Foundation
import Social
import Accounts
import SwiftyJSON

enum TimelineServiceError: Error {
    case noLinkedAccounts
    case accountAccessFailed
}

enum Result<T> {
    case Success(T)
    case Failure(TimelineServiceError)
}

typealias TimelineServiceCompletionHandler = (Result<Array<Tweet>>) -> Void

class TimelineService {
    static let timelineURL = URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
    
    class func getTimeLine(completionHandler: @escaping TimelineServiceCompletionHandler) {
        
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
                            print("TWEETS \(json)")
                            let newTweets : Array<Tweet> = json.arrayValue.map { Tweet(tweetDictionary: $0.dictionary!)}
//                            DispatchQueue.main.async() {
//                                completionHandler(Result.Success(newTweets as! [ACAccount]))
//                            }
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
                    completionHandler(Result.Failure(TimelineServiceError.noLinkedAccounts))
                }
            } else {
                completionHandler(Result.Failure(TimelineServiceError.accountAccessFailed))
            }
        })
    }
}
