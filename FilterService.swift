//
//  FilterService.swift
//  Sift
//
//  Created by Kyle Chronis on 3/13/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import Foundation

class FilterService {
    
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
        let path = Bundle.main.path(forResource: "FilterWords", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)  as! [String: Dictionary<String, Any>]
        let trumpFilters: Dictionary = dict["trump"] as! [String: Array<String>]
        let politicalFilters: Dictionary = dict["politics"] as! [String: Array<String>]
        switch filterType {
        case .none:
            return (keywords: [], accounts: [])
        case .trump:
            return (trumpFilters["keywords"]!, trumpFilters["accounts"]!)
        case .politics:
            return (politicalFilters["keywords"]! + trumpFilters["keywords"]!,
                    politicalFilters["accounts"]! + trumpFilters["accounts"]!)
        }
    }
}
