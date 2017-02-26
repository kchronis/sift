//
//  File.swift
//  Filter
//
//  Created by Kyle Chronis on 2/20/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import Foundation

// need to integrate entities https://dev.twitter.com/overview/api/entities
class Tweet {
    let id : Int
    let createdAt : String // should be a date
    let text : String
    let favoriteCount : Int
    let favorited : Bool
    let retweeted : Bool
    let inReplyToScreenName : String
    let user : User
    
    init(tweetDictionary : Dictionary<String, Any>) {
        self.id = tweetDictionary["id"] as! Int
        self.createdAt = tweetDictionary["created_at"] as! String
        self.text = tweetDictionary["text"] as! String
        self.favoriteCount = tweetDictionary["favorite_count"] as! Int
        self.favorited = (tweetDictionary["favorited"] != nil)
        self.retweeted = (tweetDictionary["retweeted"] != nil)
        self.inReplyToScreenName = tweetDictionary["in_reply_to_screen_name"] as! String
        self.user = User(userDictionary: tweetDictionary["user"] as! Dictionary<String, Any>)
        
    }
}
