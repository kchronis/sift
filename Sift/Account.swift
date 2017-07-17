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
        case trump
        case politics
        
        func name() -> String {
            switch self {
            case .trump:
                return "Just Trump"
            case .politics:
                return "All Politics"
            }
        }
        // Note(KC) https://stackoverflow.com/a/24222118/976975
        static  func allNames() -> [String] {
            var index = 0
            var names = [String]()
            while let type = FilterType(rawValue: index) {
                names.append(type.name())
                index += 1
            }
            return names
        }
    }
    
    enum FilterTime : Int {
        case morning
        case afternoon
        case evening
        case allDay
        
        func isActive() -> Bool {
            let (startDate, endDate) = self.ranges()
            let now = Date()
            return (now > startDate && now < endDate)
        }
        
        func ranges() -> (start: Date, end: Date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            switch self {
            case .morning:
                return (start: formatter.date(from: "00:00")!,
                        end: formatter.date(from: "11:59")!)
            case .afternoon:
                return (start: formatter.date(from: "12:00")!,
                        end: formatter.date(from: "16:59")!)
            case .evening:
                return (start: formatter.date(from: "17:00")!,
                        end: formatter.date(from: "23:59")!)
            case .allDay:
                return (start: formatter.date(from: "00:00")!,
                        end: formatter.date(from: "23:59")!)
            }
        }
        
        func name() -> String {
            switch self {
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
            var index = 0
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
    
    var filterType : FilterType?
    var filterTime : FilterTime?
    
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
        aCoder.encode(twitterAccount.identifier, forKey: PropertyKey.twitterAccountIdentifier)
        aCoder.encode(lastViewedTweetId, forKey: PropertyKey.lastViewedTweetId)
        aCoder.encode(filterType, forKey: PropertyKey.filterType)
        aCoder.encode(filterType, forKey: PropertyKey.filterTime)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let accountIdentifier = aDecoder.decodeObject(forKey: PropertyKey.twitterAccountIdentifier) as? String else {
            return nil
        }
        self.init(accountIdentifier: accountIdentifier)
        self.lastViewedTweetId = aDecoder.decodeObject(forKey: PropertyKey.lastViewedTweetId) as? String
        self.filterType = aDecoder.decodeObject(forKey: PropertyKey.filterType) as? FilterType
        self.filterTime = aDecoder.decodeObject(forKey: PropertyKey.filterTime) as? FilterTime
    }
}
