//
//  AccountService.swift
//  Sift
//
//  Created by Kyle Chronis on 2/22/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import Foundation
import Accounts

enum AccountServiceError: Error {
    case noLinkedAccounts
    case accountAccessFailed
}

enum AccountServiceResult<T> {
    case Success(T)
    case Failure(AccountServiceError)
}

typealias CompletionHandler = (Result<Array<ACAccount>>) -> Void

class AccountService {
    
    class func getAccounts(completionHandler: @escaping CompletionHandler) {
        
        let account = ACAccountStore()
        let accountType = account.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        account.requestAccessToAccounts(with: accountType,
                                        options: nil,
                                        completion: {(success, error) in
            if success {
                let arrayOfAccounts =
                    account.accounts(with: accountType)
                
                if (arrayOfAccounts?.count)! > 0 {
                    let twitterAccount = arrayOfAccounts?.last as! ACAccount
                    print("TWITTER ACCOUNTS \(arrayOfAccounts)")
                }
            }
        })
    }
}
