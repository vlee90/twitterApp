//
//  Tweet.swift
//  TwitterApp
//
//  Created by Vincent Lee on 10/10/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import Foundation
import UIKit

class Tweet {
    var text: String
    var userKeyDictionary: NSDictionary
    var retweet: Int
    var favorite: Int
    var profileImage: UIImage?
    var userName: String
    var profileImageURLString: String
    var id: Int
    var screenName: String
    var userID: Int
    
    init(tweetDictionary: NSDictionary) {
        self.text = tweetDictionary["text"] as String
        self.userKeyDictionary = tweetDictionary["user"] as NSDictionary
        self.retweet = tweetDictionary["retweet_count"] as Int
        self.favorite = tweetDictionary["favorite_count"] as Int
        self.userName = self.userKeyDictionary["name"] as String
        self.profileImageURLString = self.userKeyDictionary["profile_image_url"] as String
        self.id = tweetDictionary["id"] as Int
        self.screenName = self.userKeyDictionary["screen_name"] as String
        self.userID = self.userKeyDictionary["id"] as Int
    }
    
    class func parseJSONData(rawJSONData: NSData) -> [Tweet]? {
        var error: NSError?
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray {
            var tweetArray = [Tweet]()
            for individualDictionary in JSONArray {
                if let dictionary = individualDictionary as? NSDictionary {
                    var tweet = Tweet(tweetDictionary: dictionary)
                    tweetArray.append(tweet)
                }
            }
            return tweetArray
        }
        return nil
    }
}