//
//  OnboardingViewModel.swift
//  Sift
//
//  Created by Kyle Chronis on 6/6/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import Foundation

class OnboardingViewModel {
    enum Question {
        case needFilter, filterType, filterTime
        
        func next() -> Question? {
            switch self {
            case .needFilter:
                return .filterType
            case .filterType:
                return .filterTime
            case .filterTime:
                return nil
            }
        }
    }
    
    let account: Account
    
    init(account: Account) {
        self.account = account
    }
    
    func header(question: Question) -> String {
        switch question {
        case .needFilter:
            return "Need a break from politics?"
        case .filterType:
            return "What would you like to silence?"
        case .filterTime:
            return "When would you like to take a break?"
        }
    }
    
    func buttonTitles(question: Question) -> [String] {
        switch question {
        case .needFilter:
            return ["Yes", "No"]
        case .filterType:
            return Account.FilterType.allNames()
        case .filterTime:
            return Account.FilterTime.allNames()
        }
    }
    
    func setFilterForSelection(question: Question, index: Int) {
        // TEMP HACK(KC)
        // after adding the .none enum value, we can no longer use the index.
        switch question {
        case .needFilter:
            break
        case .filterType:
            self.account.filterType = Account.FilterType(rawValue: index + 1)!
            self.account.saveAccount()
        case .filterTime:
            self.account.filterTime = Account.FilterTime(rawValue: index + 1)!
            self.account.saveAccount()
        }
    }
}
