//
//  TrackDetailVC.swift
//  HearBK
//
//  Created by PC on 15/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import YouTubePlayer_Swift

var seekDuration : Float64 = 5.0

class TrackDetailVC: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var titleLbl: Label!
    @IBOutlet var trackDetailTblView: UITableView!
    @IBOutlet var trackTitle: Label!
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var audioBackView: View!
    @IBOutlet var audioProfilePicBtn: Button!
    @IBOutlet var videoBackView: YouTubePlayerView!
    @IBOutlet weak var currentTimeLbl: Label!
    @IBOutlet weak var trackProgress: UIProgressView!
    @IBOutlet weak var totalTimeLbl: Label!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var userView: View!
    @IBOutlet weak var userPictureBtn: Button!
    @IBOutlet weak var userNameLbl: Label!
    @IBOutlet weak var constraintHeightUserView: NSLayoutConstraint!//60
    
    var track : TrackModel = TrackModel.init()
    var music_type : String = String()
    var reviewData : ReviewModel = ReviewModel.init()
    var track_link : String = ""
    var isFromReview : Bool = false
    var track_id : Int = 0
    
    var player : AVPlayer = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        trackDetailTblView.register(UINib(nibName: "TrackDetailTVC", bundle: nil), forCellReuseIdentifier: "TrackDetailTVC")
        trackDetailTblView.register(UINib(nibName: "ReviewTVC", bundle: nil), forCellReuseIdentifier: "ReviewTVC")
        trackProgress.progress = 0.0
        
        userView.isHidden = true
        constraintHeightUserView.constant = 0
        
        if isFromReview
        {
            titleLbl.text = "Listener ratings"
            trackTitle.text = reviewData.track_title
            music_type = reviewData.music_type
            track_link = (music_type.lowercased() == "audio") ? reviewData.track_file : reviewData.track_link
        }
        else
        {
            titleLbl.text = "Track Detail"
            if track.track_id != 0
            {
                trackTitle.text = track.track_title
                track_link = (music_type.lowercased() == "audio") ? track.track_file : track.track_link
                setupData()
            }
            else
            {
                getTrackDetail()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
            self.extendedLayoutIncludesOpaqueBars = true
            edgesForExtendedLayout = UIRectEdge.bottom
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.pause()
    }
    
    //MARK:- Set Track Detail
    func setupData()
    {
        if music_type.lowercased() == "audio" {
            audioBackView.isHidden = false
            videoBackView.isHidden = true
            nextBtn.isEnabled = false
            previousBtn.isEnabled = false
            
            let playerItem = AVPlayerItem(url: URL(string: track_link)!)
            player = AVPlayer(playerItem: playerItem)
            
            player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { (time) in
                if self.player.currentItem?.status == .readyToPlay
                {
                    self.nextBtn.isEnabled = true
                    self.previousBtn.isEnabled = true
                    let currentTime:Double = self.player.currentItem!.currentTime().seconds
                    print(Int(currentTime))
                    self.currentTimeLbl.text = getHoursMinutesSecondsFrom(seconds: currentTime)
                    let duration:Double = self.player.currentItem!.asset.duration.seconds
                    print(Int(duration))
                    self.totalTimeLbl.text = getHoursMinutesSecondsFrom(seconds: duration)
                    self.trackProgress.progress = Float((currentTime * 100)/duration)/100.0
                }
            }
        }else {
            audioBackView.isHidden = true
            videoBackView.isHidden = false
            
            if let videoID = track_link.components(separatedBy: "=").last {
                print(videoID)
                //    playVideo(videoIdentifier: videoID)
                videoBackView.loadVideoID(videoID)
                videoBackView.play()
            }
            
            let videoURL : String = (track_link)
            if let videoId : String = extractYoutubeIdFromLink(link:videoURL)
            {
                videoBackView.loadVideoID(videoId)
            }
            else
            {
                displayToast("Failed to load video.")
            }
        }
    }
    
    
    //MARK: - Taleview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromReview
        {
            return 1
        }
       return track.feedback.count
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFromReview
        {
            let cell = trackDetailTblView.dequeueReusableCell(withIdentifier: "ReviewTVC", for: indexPath) as! ReviewTVC
            AppDelegate().sharedDelegate().setUserBackgroundImage(cell.profilePicBtn, reviewData.image)
            
            cell.nameLbl.text = reviewData.name
            cell.descriptionLbl.text = reviewData.comment
            cell.rateView.rating = reviewData.rating
            
            cell.serviceRateView.rating = Double(reviewData.service)
            cell.buyAgainRateView.rating = Double(reviewData.recommend)
            cell.listnerRateView.rating = Double(reviewData.response)
            return cell
        }
        else
        {
            let cell = trackDetailTblView.dequeueReusableCell(withIdentifier: "TrackDetailTVC", for: indexPath) as! TrackDetailTVC
            let dict : ReviewModel = track.feedback[indexPath.row]
            AppDelegate().sharedDelegate().setUserBackgroundImage(cell.profileBtnImg, dict.image)
            cell.nameLbl.text = dict.name
            cell.descriptionLbl.text = dict.comment
            AppDelegate().sharedDelegate().setUserBackgroundImage(cell.profileBtnImg, dict.image)
            if dict.rating != nil {
                cell.rateBtn.setTitle(setFlotingRating(dict.rating), for: .normal)
                cell.rateBtn.isHidden = false
            }else{
                cell.rateBtn.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isFromReview
        {
            if track.feedback[indexPath.row].isMusicianFeedback == 1 {
                displayToast("Feedback already given")
            } else {
                let vc : RatingVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
                vc.listener_id = track.feedback[indexPath.row].id
                vc.order_id = track.track_id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK: - Button click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func clickToPlayBtn(_ sender: Any) {
        playBtn.isSelected = !playBtn.isSelected
        if playBtn.isSelected
        {
            player.play()
        }
        else
        {
            player.pause()
        }
    }
    
    @IBAction func clickToPlayBack(_ sender: Any) {
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = playerCurrentTime - seekDuration
        
        if newTime < 0 {
            newTime = 0
        }
        let time2: CMTime = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
        player.seek(to: time2)
    }
    
    @IBAction func clickToPlayNext(_ sender: Any) {
        guard let duration  = player.currentItem?.duration else{
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = playerCurrentTime + seekDuration
        
        if newTime < CMTimeGetSeconds(duration) {
            
            let time2: CMTime = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
            player.seek(to: time2)
        }
    }

    //MARK:- Service call to get track detail
    func getTrackDetail()
    {
        var param : [String : Any] = [String : Any]()
        param["track_id"] = track_id
        param["user_id"] = ""
        
        APIManager.shared.serviceCallToGetTrackDetail(param) { (data) in
            
            self.userView.isHidden = false
            self.constraintHeightUserView.constant = 60
            self.track = TrackModel.init()
            self.track.track_id = self.track_id
            if let temp : String = data["creater_image"] as? String
            {
                AppDelegate().sharedDelegate().setUserBackgroundImage(self.userPictureBtn, temp)
            }
            if let temp : String = data["creater_name"] as? String
            {
                self.userNameLbl.text = temp
            }
            if let temp : String = data["track_title"] as? String
            {
                self.trackTitle.text = temp
            }
            if let temp : String = data["music_type"] as? String
            {
                self.music_type = temp
                self.track.music_type = temp
            }
            if let temp : String = data["track_link"] as? String, temp != ""
            {
                self.track_link = temp
                self.track.track_link = temp
            }
            else if let temp : String = data["track_file"] as? String, temp != ""
            {
                self.track_link = temp
                self.track.track_link = temp
            }
            if let tempData : [[String : Any]] = data["feedbackList"] as? [[String : Any]]
            {
                self.track.feedback.append(ReviewModel.init(dict: tempData[0]))
            }
            self.setupData()
            self.trackDetailTblView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
