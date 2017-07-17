//
//  FilterService.swift
//  Sift
//
//  Created by Kyle Chronis on 3/13/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import Foundation

class FilterService {
    //MARK: Temp
    // keywords
    static let trumpKeywords = ["trump", "kellyanne", "potus", "flotus", "president", "bannon", "sean spicer", "white house", "ivanka trump", "mar a lago", "jeff sessions", "kushner"]
    static let politicsKeywords = ["republicans", "democrats", "health care", "obamacare", "comey", "putin"] + trumpKeywords
    // twitter accounts
    static let trumpAccounts = ["potus", "flotus", "realdonaldtrump", "ivankatrump", "erictrump", "donaldjyrumpjr"]
    static let politicalAccounts = ["chucktodd"]
    
    class func execute(account: Account, tweets: Array<Tweet>) -> (filteredTweets: Array<Tweet>, removedCount: Int) {
        var predicates = Array<NSPredicate>()
        guard let filterType = account.filterType else {
                    return (filteredTweets: tweets, removedCount: 0)
        }
        
        // check for existence of a filter time and that the first is currently active
        guard let filterTime = account.filterTime, filterTime.isActive() else {
            return (filteredTweets: tweets, removedCount: 0)
        }
        
        let (keywords, accounts) = self.filters(filterType: filterType)
        for keyword in keywords {
            predicates.append(NSPredicate(format: "NOT(%K CONTAINS[cd] %@)", "text", keyword))
            predicates.append(NSPredicate(format: "NOT(%K CONTAINS[cd] %@)", "quotedTweet.text",keyword))
        }
        for account in accounts {
            predicates.append(NSPredicate(format: "%K != %@", "screen_name", account))
            predicates.append(NSPredicate(format: "%K != %@", "in_reply_to_screen_name", account))
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let filterTweets = (tweets as NSArray).filtered(using: compoundPredicate) as! Array<Tweet>
        return (filteredTweets: filterTweets, removedCount: (tweets.count - filterTweets.count))
    }
    
    private class func filters(filterType: Account.FilterType) -> (keywords: Array<String>, accounts: Array<String>) {
        switch filterType {
        case .trump:
            return (FilterService.trumpKeywords, FilterService.trumpAccounts)
        case .politics:
            return (FilterService.trumpKeywords + FilterService.trumpKeywords, FilterService.politicalAccounts)
        }
    }
}
