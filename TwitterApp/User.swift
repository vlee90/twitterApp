//
//  User.swift
//  TwitterApp
//
//  Created by Vincent Lee on 10/11/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import Foundation
import UIKit

class User {
    var profileImageURLString: String?
    var userName: String?
    var screenName: String?
    var profileImage: UIImage?
    var dictionary: NSDictionary?
    
    init() {
    }
    
    class func parseJSONData(rawJSONData: NSData) -> NSDictionary? {
        var error: NSError?
        if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSDictionary {
            return JSONDictionary
        }
        println("parseJSONData for User passed nil")
        return nil
    }
}