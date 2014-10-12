//
//  NetworkController.swift
//  TwitterApp
//
//  Created by Vincent Lee on 10/10/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import Foundation
import Accounts
import Social

class NetworkController {
//    MARK: Properties
    var twitterAccount: ACAccount?
    let imageQueue = NSOperationQueue()
    let APIDictionary: [String : String] = ["Home" : "https://api.twitter.com/1.1/statuses/home_timeline.json",
        "User" : "https://api.twitter.com/1.1/statuses/user_timeline.json"]
    var imageCashe = Dictionary <String, NSData>()
    
    init() {
        self.imageQueue.maxConcurrentOperationCount = 5
    }
    
//    MARK: Network Tweet Calls
    func fetchTweetArray(JSONurl: String, parameters: NSDictionary?, completionHandler: (error: String?, tweets: [Tweet]?) -> Void) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (requestGranted: Bool, error: NSError?) -> Void in
            println("Tweet Request Granted:\(requestGranted)")
            if requestGranted == true {
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                let url = NSURL(string: JSONurl)
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: parameters)
                twitterRequest.account = self.twitterAccount
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    switch httpResponse.statusCode {
                    case 200...299:
                        println("fetchTweetArray: \(httpResponse.statusCode)")
                        var tweets = Tweet.parseJSONData(data)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(error: nil, tweets: tweets)
                        })
                    case 400...499:
                        println("fetchTweetArray: \(httpResponse.statusCode)")
                    case 500...599:
                        println("fetchTweetArray: \(httpResponse.statusCode)")
                    default:
                        println("fetchTweetArray: \(httpResponse.statusCode)")
                    }
                })
            }
        }
    }
    
    func fetchUserInfo(parameters: NSDictionary?, completionHandler: (error: String?, userDictionary: NSDictionary?) -> Void) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (requestGranted: Bool, error: NSError?) -> Void in
            println("User Request Granted:\(requestGranted)")
            if requestGranted == true {
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                let url = NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    switch httpResponse.statusCode {
                    case 200...299:
                        println("fetchUserInfo: \(httpResponse.statusCode)")
                        var userInfo = User.parseJSONData(data)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(error: nil, userDictionary: userInfo)
                        })
                    case 400...499:
                        println("fetchUserInfo: \(httpResponse.statusCode)")
                    case 500...599:
                        println("fetchUserInfo: \(httpResponse.statusCode)")
                    default:
                        println("fetchUserInfo: \(httpResponse.statusCode)")
                    }
                })
            }
        }
    }
    
    
//  MARK: Network Image Calls
    func fetchImageForObject(object: AnyObject, completionHandler: (image: UIImage, cashe: Dictionary <String, NSData>) -> Void) {
        self.imageQueue.addOperationWithBlock { () -> Void in
            if let tweet = object as? Tweet {
                let urlInput = tweet.profileImageURLString
                let inCashe = self.checkImageCashe(self.imageCashe, checkedURL: urlInput)
                if inCashe == false {
                    let url = NSURL(string: urlInput)
                    let imageData = NSData(contentsOfURL: url)
                    let profileImage = UIImage(data: imageData)
                    self.imageCashe[urlInput] = imageData
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completionHandler(image: profileImage, cashe: self.imageCashe)
                    })
                }
                else {
                    let imageData = self.imageCashe["\(urlInput)"]! as NSData
                    let profileImage = UIImage(data: imageData)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completionHandler(image: profileImage, cashe: self.imageCashe)
                    })
                }
            }
            else if let user = object as? User {
                let urlInput = user.profileImageURLString!
                let inCashe = self.checkImageCashe(self.imageCashe, checkedURL: urlInput)
                if inCashe == false {
                    let url = NSURL(string: urlInput)
                    let imageData = NSData(contentsOfURL: url)
                    let profileImage = UIImage(data: imageData)
                    self.imageCashe[urlInput] = imageData
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completionHandler(image: profileImage, cashe: self.imageCashe)
                    })
                }
                else {
                    let imageData = self.imageCashe["\(urlInput)"]! as NSData
                    let profileImage = UIImage(data: imageData)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completionHandler(image: profileImage, cashe: self.imageCashe)
                    })
                }
            }
            else if let urlInput = object as? String {
                let inCashe = self.checkImageCashe(self.imageCashe, checkedURL: urlInput)
                    if inCashe == false {
                        let url = NSURL(string: urlInput)
                        let imageData = NSData(contentsOfURL: url)
                        let profileImage = UIImage(data: imageData)
                        self.imageCashe[urlInput] = imageData
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(image: profileImage, cashe: self.imageCashe)
                        })
                    }
                    else {
                        let imageData = self.imageCashe["\(urlInput)"]! as NSData
                        let profileImage = UIImage(data: imageData)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(image: profileImage, cashe: self.imageCashe)
                        })
                }
            }
        }
    }
    
    func checkImageCashe(imageCashe: [String : NSData], checkedURL: String) -> Bool {
        var numConfirm = 0
        var bool = true
        for x in imageCashe.keys {
            if x == checkedURL {
                numConfirm++
            }
            else {
            }
        }
        if numConfirm > 0 {
            bool = true
        }
        else {
            bool = false
        }
        return bool
    }
}