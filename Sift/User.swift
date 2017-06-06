//
//  User.swift
//  Sift
//
//  Created by Kyle Chronis on 2/20/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import Foundation

class User : NSObject {
    let userName : String
    let name : String
    let profileImageURL : URL?
    let verified : Bool
    unowned let tweet : Tweet
    
    init(userDictionary: Dictionary<String, Any>, tweet: Tweet) {
        self.userName = "@" + (userDictionary["screen_name"] as! String)
        self.name = userDictionary["name"] as! String
        self.profileImageURL = URL(string: userDictionary["profile_image_url"] as! String)
        self.verified = userDictionary["verified"] as! Bool
        self.tweet = tweet
    }
}
