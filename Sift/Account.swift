//
//  Account.swift
//  Sift
//
//  Created by Kyle Chronis on 3/12/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import Foundation
import Accounts

class Account : NSObject, NSCoding {
    //MARK: Properties
    let twitterAccount : ACAccount
    var lastViewedTweetId : Int?
    
    //MARK: Types
    struct PropertyKey {
        static let twitterAccountIdentifier = "twitterAccountIdentifier"
        static let lastViewedTweetId = "lastViewedTweetId"
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("account")
    
    convenience init?(accountIdentifier: String) {
        let store = ACAccountStore()
        guard let twitterAccount = store.account(withIdentifier: accountIdentifier) else {
            return nil
        }
        
        self.init(twitterAccount: twitterAccount)
    }
    
    init(twitterAccount: ACAccount) {
        self.twitterAccount = twitterAccount
    }
    
    class func loadAccount() -> Account? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Account.ArchiveURL.path) as? Account
    }
    
    func saveAccount() {
        NSKeyedArchiver.archiveRootObject(self, toFile: Account.ArchiveURL.path)
    }
    
    //MARK: NSCoding Protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(twitterAccount.identifier, forKey: PropertyKey.twitterAccountIdentifier)
        aCoder.encode(lastViewedTweetId, forKey: PropertyKey.lastViewedTweetId)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let accountIdentifier = aDecoder.decodeObject(forKey: PropertyKey.twitterAccountIdentifier) as? String else {
            return nil
        }
        self.init(accountIdentifier: accountIdentifier)
        self.lastViewedTweetId = aDecoder.decodeObject(forKey: PropertyKey.lastViewedTweetId) as? Int
    }
    
}
