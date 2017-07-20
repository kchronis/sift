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
    static let trumpAccounts = ["potus", "flotus", "realdonaldtrump", "ivankatrump", "erictrump", "donaldjtrumpjr"]
    static let politicalAccounts = ["chucktodd"]
    
    typealias FilterResult = (filteredTweets: Array<Tweet>, filterEnabled: Bool, removedCount: Int)
    
    class func execute(account: Account, tweets: Array<Tweet>) -> FilterResult {
        var predicates = Array<NSPredicate>()
        
        let filterType = account.filterType
        let filterTime = account.filterTime
        
        guard filterType != .none && filterTime.isActive() else {
            return (filteredTweets: tweets, filterEnabled: false, removedCount: 0)
        }
        
        
        let (keywords, accounts) = self.filters(filterType: filterType)
        for keyword in keywords {
            predicates.append(NSPredicate(format: "NOT(%K CONTAINS[cd] %@)", "text", keyword))
            predicates.append(NSPredicate(format: "NOT(%K CONTAINS[cd] %@)", "quotedTweet.text",keyword))
        }
        for account in accounts {
            predicates.append(NSPredicate(format: "%K != %@", "user.userName", account))
            predicates.append(NSPredicate(format: "%K != %@", "inReplyToScreenName", account))
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let filterTweets = (tweets as NSArray).filtered(using: compoundPredicate) as! Array<Tweet>
        return (filteredTweets: filterTweets, filterEnabled: true, removedCount: (tweets.count - filterTweets.count))
    }
    
    private class func filters(filterType: Account.FilterType) -> (keywords: Array<String>, accounts: Array<String>) {
        switch filterType {
        case .none:
            return (keywords: [], accounts: [])
        case .trump:
            return (FilterService.trumpKeywords, FilterService.trumpAccounts)
        case .politics:
            return (FilterService.trumpKeywords + FilterService.trumpKeywords, FilterService.politicalAccounts)
        }
    }
}
