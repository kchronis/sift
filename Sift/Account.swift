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
    enum FilterType : Int {
        case none
        case trump
        case politics
        
        func name() -> String {
            switch self {
            case .none:
                return ""
            case .trump:
                return "Just Trump"
            case .politics:
                return "All Politics"
            }
        }
        // Note(KC) https://stackoverflow.com/a/24222118/976975
        static  func allNames() -> [String] {
            var index = 1 // skip none
            var names = [String]()
            while let type = FilterType(rawValue: index) {
                names.append(type.name())
                index += 1
            }
            return names
        }
    }
    
    enum FilterTime : Int {
        case none
        case morning
        case afternoon
        case evening
        case allDay
        
        func isActive() -> Bool {
            let hour = Calendar.current.component(.hour, from: Date())
            let filterRange = self.range()
            return filterRange.contains(hour)
        }
        
        private func range() -> CountableClosedRange<Int> {
            switch self {
            case .none:
                return 0...(-1) // invalid range
            case .morning:
                return 0...11
            case .afternoon:
                return 12...16
            case .evening:
                return 17...23
            case .allDay:
                return 0...23
            }
        }
        
        func name() -> String {
            switch self {
            case .none:
                return ""
            case .morning:
                return "Morning"
            case .afternoon:
                return "Afternoon"
            case .evening:
                return "Evening"
            case .allDay:
                return "All Day"
            }
        }
        
        // Note(KC) https://stackoverflow.com/a/24222118/976975
        static func allNames() -> [String] {
            var index = 1 // skip none
            var names = [String]()
            while let time = FilterTime(rawValue: index) {
                names.append(time.name())
                index += 1
            }
            return names
        }
    }
    
    //MARK: Properties
    let twitterAccount : ACAccount
    var lastViewedTweetId : String?
    
    var filterType : FilterType = .none
    var filterTime : FilterTime = .none
    
    //MARK: Types
    struct PropertyKey {
        static let twitterAccountIdentifier = "twitterAccountIdentifier"
        static let lastViewedTweetId = "lastViewedTweetId"
        static let filterType = "filterType"
        static let filterTime = "filterTime"
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
        aCoder.encode(self.twitterAccount.identifier, forKey: PropertyKey.twitterAccountIdentifier)
        aCoder.encode(self.lastViewedTweetId, forKey: PropertyKey.lastViewedTweetId)
        aCoder.encode(self.filterType.rawValue, forKey: PropertyKey.filterType)
        aCoder.encode(self.filterTime.rawValue, forKey: PropertyKey.filterTime)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let accountIdentifier = aDecoder.decodeObject(forKey: PropertyKey.twitterAccountIdentifier) as? String else {
            return nil
        }
        self.init(accountIdentifier: accountIdentifier)
        self.lastViewedTweetId = aDecoder.decodeObject(forKey: PropertyKey.lastViewedTweetId) as? String
        self.filterType = FilterType(rawValue: aDecoder.decodeInteger(forKey: PropertyKey.filterType))!
        self.filterTime = FilterTime(rawValue: aDecoder.decodeInteger(forKey: PropertyKey.filterTime))!
    }
}
