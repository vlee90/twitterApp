//
//  TimelineViewController.swift
//  TwitterApp
//
//  Created by Vincent Lee on 10/10/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit
import Accounts


class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    //  MARK: IB Outlets
    
    @IBOutlet weak var timelineTableViewHeader: UIView!
    @IBOutlet weak var timelineTableView: UITableView!
    @IBOutlet weak var headerProfileImageView: UIImageView!
    @IBOutlet weak var headerUserNameLabel: UILabel!
    @IBOutlet weak var headerScreenNameLabel: UILabel!
    
    
    //  Mark: Properties
    var user: User?
    var tweetArray: [Tweet]?
    var twitterAccount: ACAccount?
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var timelineTypeHome = true
    var parameter: NSDictionary?
    var profileImageURLString: String?
    var profileImage: UIImage?
    var userName: String?
    var screenName: String?
    var imageCashe = Dictionary <String, NSData>()
    
    //  Mark: RunTime
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setUpHeader()
    }
    
    // MARK: TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweetArray != nil {
            return self.tweetArray!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        let tweet = self.tweetArray?[indexPath.row]
        cell.tweetLabel.text = tweet?.text
        cell.userNameLabel.text = tweet?.userName
        cell.screenNameLabel.text = "@\(tweet!.screenName)"
        if tweet?.profileImage != nil {
            cell.profileImageView?.image = tweet?.profileImage
        }
        else {
            self.appDelegate.networkController.fetchImageForObject(tweet!, completionHandler: { (image, cashe) -> Void in
                let cellForImage = self.timelineTableView.cellForRowAtIndexPath(indexPath) as TweetCell?
                cellForImage?.profileImageView.image = image as UIImage
                self.imageCashe = cashe
            })
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DETAIL_VC") as DetailViewController
        var indexPath = tableView.indexPathForSelectedRow()
        var detailTweet = self.tweetArray![indexPath!.row] as Tweet
        detailVC.tweet = detailTweet
        detailVC.imageCashe = self.imageCashe
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func setUpTable() {
        self.timelineTableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        if self.timelineTypeHome == true {
            println("Called HomeTimeline")
            let homeURL = self.appDelegate.networkController.APIDictionary["Home"]! as String
            self.appDelegate.networkController.fetchTweetArray(homeURL, parameters: nil) { (error, tweets) -> Void in
                if error != nil {
                    println("Error")
                }
                else {
                    self.tweetArray = tweets
                    self.timelineTableView.reloadData()
                }
            }
        }
        else {
            println("Called UserTimeline")
            let userURL = self.appDelegate.networkController.APIDictionary["User"]! as String
            self.appDelegate.networkController.fetchTweetArray(userURL, parameters: parameter) { (error, tweets) -> Void in
                if error != nil {
                    println("Error")
                }
                else {
                    self.tweetArray = tweets
                    self.timelineTableView.reloadData()
                }
            }
        }
    }
    
    func setUpHeader() {
        if self.timelineTypeHome == true {
            self.appDelegate.networkController.fetchUserInfo(nil, completionHandler: { (error, userDictionary) -> Void in
                if error != nil {
                    println("Error")
                }
                else {
                    self.user = User()
                    self.setupUser(self.user!, dictionary: userDictionary!)
                    self.headerScreenNameLabel.text = "@\(self.user!.screenName!)"
                    self.headerUserNameLabel.text = self.user!.userName!
                    self.appDelegate.networkController.fetchImageForObject(self.user!, completionHandler: { (image, cashe) -> Void in
                        self.headerProfileImageView.image = image as UIImage
                        self.imageCashe = cashe
                    })
                }
            })
        }
        else {
            self.headerScreenNameLabel.text = "@\(self.user!.screenName!)"
            self.headerUserNameLabel.text = self.user!.userName!
            self.appDelegate.networkController.fetchImageForObject(self.user!, completionHandler: { (image, cashe) -> Void in
                self.headerProfileImageView.image = image as UIImage
                self.imageCashe = cashe
            })
        }
    }

    
    func setupUser(user: User, dictionary: NSDictionary) {
        user.dictionary = dictionary
        user.userName = user.dictionary!["name"] as? String
        user.screenName = user.dictionary!["screen_name"] as? String
        user.profileImageURLString = user.dictionary!["profile_image_url"] as? String
        appDelegate.networkController.fetchImageForObject(user, completionHandler: { (image, cashe) -> Void in
            user.profileImage = image as UIImage
            self.imageCashe = cashe
        })

    }
}
