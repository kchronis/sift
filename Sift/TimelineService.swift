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

// NEED Better error handling
enum TimelineServiceError: Error {
    case networkError
}

enum TimelineServiceResult<T> {
    case success(T)
    case failure(TimelineServiceError)
}

typealias TimelineServiceCompletionHandler = (TimelineServiceResult<Array<Tweet>>) -> Void

class TimelineService {
    static let timelineURL = URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
    
    class func getTimeLine(
        account: Account,
        completionHandler: @escaping TimelineServiceCompletionHandler) {
        
        var parameters = ["include_rts" : "1",
                          "trim_user" : "0",
                          "exclude_replies" : "1",
                          "count" : "300"]
        if let lastViewedTweetId = account.lastViewedTweetId {
            parameters["since_id"] = String(lastViewedTweetId)
        }
        
        let postRequest = SLRequest(
            forServiceType: SLServiceTypeTwitter,
            requestMethod: SLRequestMethod.GET,
            url: self.timelineURL!,
            parameters: parameters)
        
        postRequest?.account = account.twitterAccount
        
        postRequest?.perform(handler: {(responseData, urlResponse, error) in
            if error != nil {
                print("ERROR \(error)")
            }
            let json = JSON(data: responseData!)
            if json.count > 0 {
                print("COUNT \(json.count)")
                let newTweets : Array<Tweet> = json.arrayValue.map { Tweet(tweetDictionary: $0.dictionaryObject!)}
                DispatchQueue.main.async() {
                    completionHandler(
                        TimelineServiceResult.success(newTweets)
                    )
                }
            }
        })
    }
}
