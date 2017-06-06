//
//  File.swift
//  Sift
//
//  Created by Kyle Chronis on 2/20/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import Foundation
import SwiftyJSON

// need to integrate entities https://dev.twitter.com/overview/api/entities
class Tweet : NSObject {
    static let timestampFormatter : DateFormatter = {
        let timestampFormatter = DateFormatter()
        timestampFormatter.locale = Locale(identifier: "en_US_POSIX")
        timestampFormatter.dateFormat = "E MMM d HH:mm:ss Z yyyy"
        return timestampFormatter
    }()
    let id : Int
    let text : String
    let favoriteCount : Int
    let favorited : Bool
    let retweeted : Bool
    var createdAt : Date?
    var inReplyToScreenName : String?
    var retweetedTweet : Tweet?
    var quotedTweet : Tweet?
    // unwrapped optional so user will default to nil, 2 phase initialization is complete and
    // we can then pass in self to the User initializer.
    var user : User!
    
    init(tweetDictionary : Dictionary<String, Any>) {
        self.id = tweetDictionary["id"] as! Int
        self.text = tweetDictionary["text"] as! String
        self.favoriteCount = tweetDictionary["favorite_count"] as! Int
        self.favorited = (tweetDictionary["favorited"] != nil)
        self.retweeted = (tweetDictionary["retweeted"] != nil)
        self.createdAt = Tweet.timestampFormatter.date(from: tweetDictionary["created_at"] as! String)
        self.inReplyToScreenName = tweetDictionary["in_reply_to_screen_name"] as? String
        //WARNING: FIX ME
        super.init()
        self.user = User(userDictionary: tweetDictionary["user"] as! Dictionary<String, Any>,
                         tweet: self)
        if let retweetedDictionary = tweetDictionary["retweeted_status"] as? Dictionary<String, Any> {
            self.retweetedTweet = Tweet(tweetDictionary: retweetedDictionary)
        }
        if let quotedTweet = tweetDictionary["quoted_status"] as? Dictionary<String, Any> {
            self.quotedTweet = Tweet(tweetDictionary: quotedTweet)
        }
    }
    
    func formattedTweetedAt() -> String {
        return self.stringFromTimeInterval(interval: (self.createdAt?.timeIntervalSinceNow)!)
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let ti = abs(Int(interval))
        let secondsInMinute = 60
        let secondsInHour = 3600
        let secondsInDay = 86400
        let secondsInWeek = 604800
        
        var tweetedAtString : String
        
        switch ti {
        case let x where x < secondsInMinute:
            tweetedAtString = "\(x)s"
        case let x where x < secondsInHour:
            tweetedAtString = "\(x/secondsInMinute)m"
        case let x where x < secondsInDay:
            tweetedAtString = "\(x/secondsInHour)h"
        case let x where x < secondsInWeek:
            tweetedAtString = "\(x/secondsInDay)d"
        default:
            tweetedAtString = "\(ti/secondsInWeek)w"
        }
        return tweetedAtString
    }
}
