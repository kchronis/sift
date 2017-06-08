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
    
    func title() -> String {
        switch self {
        case .noLinkedAccounts:
            return "No Linked Accounts"
        case .accountAccessFailed:
            return "Access Denied"
        }
    }
    
    func description() -> String {
        let baseInstruction = "Please navigate to Settings -> Twitter "
        switch self {
        case .noLinkedAccounts:
            return baseInstruction + "and add an account."
        case .accountAccessFailed:
            return baseInstruction + "to enable Sift to use your account."
        }
    }
}

enum AccountServiceResult<T> {
    case success(T)
    case failure(AccountServiceError)
}

typealias AccountServiceCompletionHandler = (AccountServiceResult<Array<ACAccount>>) -> Void

class AccountService {
    
    class func getAccounts(completionHandler: @escaping AccountServiceCompletionHandler) {
        
        let account = ACAccountStore()
        let accountType = account.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        account.requestAccessToAccounts(
            with: accountType,
            options: nil,
            completion: {(success, error) in
                DispatchQueue.main.async {
                    if success {
                        let arrayOfAccounts = account.accounts(with: accountType)
                        
                        if (arrayOfAccounts?.count)! > 0 {
                            completionHandler(AccountServiceResult.success(arrayOfAccounts as! [ACAccount]))
                        }
                        else {
                            completionHandler(AccountServiceResult.failure(AccountServiceError.noLinkedAccounts))
                        }
                    }
                    else {
                        completionHandler(AccountServiceResult.failure(AccountServiceError.accountAccessFailed))
                    }
                }
        })
    }
}
