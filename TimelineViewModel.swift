//
//  TimelineViewModel.swift
//  Sift
//
//  Created by Kyle Chronis on 6/8/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import Foundation

class TimelineViewModel {
    typealias TimelineCompletionHandler = (String) -> Void
    
    let account: Account
    var tweets = [Tweet]()
    
    init(account: Account) {
        self.account = account
    }
    
    func getTimeline(completionHandler: @escaping TimelineCompletionHandler) {
        TimelineService.getTimeLine(
        account: self.account) { (result : TimelineServiceResult<Array<Tweet>>) in
            switch result  {
            case .success(let tweets):
                let filterResults = FilterService.execute(account: self.account, tweets: tweets)
                self.tweets.insert(contentsOf: filterResults.filteredTweets, at: 0)
                completionHandler(self.filterResultsToString(filterResults))
            case .failure(let error):
                // handle error
                completionHandler("Error")
                print("ERROR \(error)")
            }
        }
    }
    
    func rowCount() -> Int {
        return self.tweets.count
    }
    
    func tweet(for indexPath: IndexPath) -> Tweet {
        return self.tweets[indexPath.row]
    }
    
    func setLastViewedIndexPath(indexPath: IndexPath) {
        self.account.lastViewedTweetId = self.tweets[indexPath.row].id
    }
    
    func lastViewedIndexPath() -> IndexPath {
        if let lastViewedId = self.account.lastViewedTweetId,
            let index =  self.tweets.index(where: { $0.id == lastViewedId }) {
            return IndexPath(row: index, section: 0)
        }
        else {
            return IndexPath(row: (self.tweets.count - 1), section: 0)
        }
    }
    
    private func filterResultsToString(_ filterResults: FilterService.FilterResult) -> String {
        if !filterResults.filterEnabled {
            return "Filtering disabled."
        }
        else {
            return "\(filterResults.removedCount) tweets removed!"
        }
    }
    
}
