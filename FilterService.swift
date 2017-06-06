//
//  FilterService.swift
//  Sift
//
//  Created by Kyle Chronis on 3/13/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import Foundation

class FilterService {
    //MARK Temp
    static let trumpKeywords = ["trump", "kellyanne", "potus", "flotus", "president", "bannon", "sean spicer", "white house"]
    static let politicsKeywords = ["republicans", "democrats", "health care", "obamacare"] + trumpKeywords
    
    class func execute(account: Account, tweets: Array<Tweet>) -> (filteredTweets: Array<Tweet>, removedCount: Int) {
        var predicates = Array<NSPredicate>()
        for keyword in trumpKeywords {
            predicates.append(NSPredicate(format: "NOT(%K CONTAINS[cd] %@)", "text", keyword))
            predicates.append(NSPredicate(format: "NOT(%K CONTAINS[cd] %@)", "quotedTweet.text",keyword))
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let filterTweets = (tweets as NSArray).filtered(using: compoundPredicate) as! Array<Tweet>
        return (filteredTweets: filterTweets, removedCount: tweets.count - filterTweets.count)
    }
}
