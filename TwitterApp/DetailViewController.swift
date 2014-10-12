//
//  DetailViewController.swift
//  TwitterApp
//
//  Created by Vincent Lee on 10/10/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

//    MARK: IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
//    MARK: Properties
    var user: User?
    var tweet: Tweet?
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var profileImage: UIImage?
    var userName: String?
    var favorite: Int?
    var retweet: Int?
    var text: String?
    var screenName: String?
    var profileImageURLString: String?
    var imageCashe = Dictionary <String, NSData>()
    
//    MARK: Runtime
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProperties()
        setupView()
        
        self.profileImageView.userInteractionEnabled = true
        var press = UITapGestureRecognizer(target: self, action: "profileImageClicked:")
        self.profileImageView.addGestureRecognizer(press)
        
    }
    
    func profileImageClicked(reco: UIGestureRecognizer) {
        var userTimelineVC = self.storyboard?.instantiateViewControllerWithIdentifier("TIMELINE_VC") as TimelineViewController
        userTimelineVC.timelineTypeHome = false
        setupTimelineProperties(userTimelineVC)
        self.navigationController?.pushViewController(userTimelineVC, animated: true)
    }
    
    func setupProperties() {
        self.userName = tweet!.userName
        self.favorite = tweet!.favorite
        self.retweet = tweet!.retweet
        self.text = tweet!.text
        self.screenName = tweet!.screenName
        self.profileImageURLString = tweet!.profileImageURLString
        appDelegate.networkController.fetchImageForObject(self.tweet!, completionHandler: { (image, cashe) -> Void in
            self.profileImageView.image = image
            self.profileImage = image
            self.imageCashe = cashe
        })
        var userX = User()
        userX.userName = self.userName
        userX.profileImageURLString = self.profileImageURLString
        userX.profileImage = self.profileImageView.image
        userX.screenName = self.screenName
        self.user = userX
    }
    
    
    func setupView() {
        self.userNameLabel.text = self.userName
        self.favoriteLabel.text = "Favorite #: \(self.favorite!)"
        self.retweetLabel.text = "Retweet #: \(self.retweet!)"
        self.tweetLabel.text = self.text
        self.screenNameLabel.text = self.screenName
    }
    
    func setupTimelineProperties(timeline: TimelineViewController) {
        timeline.userName = self.userName!
        timeline.screenName = self.screenName!
        timeline.parameter = ["screen_name" : "\(self.screenName!)"]
        timeline.profileImage = user?.profileImage
        timeline.profileImageURLString = self.profileImageURLString
        timeline.user = self.user
        timeline.imageCashe = self.imageCashe
        
    }
    
}
