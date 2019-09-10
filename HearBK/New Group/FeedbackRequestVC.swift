//
//  FeedbackRequestVC.swift
//  HearBK
//
//  Created by PC on 29/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import YouTubePlayer_Swift

class FeedbackRequestVC: UIViewController {

    @IBOutlet var profileBtn: Button!
    @IBOutlet var nameLbl: Label!
    @IBOutlet var subLbl: Label!
    @IBOutlet var feedbackTxt: TextField!
    
    @IBOutlet var slider: myCustomSlider!
    @IBOutlet var priceLbl: Label!
    
    @IBOutlet var playBackView: View!
    @IBOutlet var playProfileBtn: Button!
    @IBOutlet var minLbl: Label!
    @IBOutlet var maxLbl: Label!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var playBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet var videoBackView: YouTubePlayerView!
    
    var selectedRequest : FeedBackModel = FeedBackModel()
    var player : AVPlayer = AVPlayer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = 2
        progressView.progress = 0.0
        setTrackData()
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
    
    //MARK:- Set Track detail
    func setTrackData()  {
        print(selectedRequest)
        nameLbl.text = selectedRequest.display_name
        subLbl.text = selectedRequest.track_title
        priceLbl.text = displayPriceWithCurrency(Float(selectedRequest.price))
        
        
        if selectedRequest.music_type.lowercased() == "audio" {
            playBackView.isHidden = false
            videoBackView.isHidden = true
            let playerItem = AVPlayerItem(url: URL(string: selectedRequest.track_file)!)
            player = AVPlayer(playerItem: playerItem)
            
            player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { (time) in
                if self.player.currentItem?.status == .readyToPlay
                {
                    let currentTime:Double = self.player.currentItem!.currentTime().seconds
                    self.minLbl.text = getHoursMinutesSecondsFrom(seconds: currentTime)
                    let duration:Double = self.player.currentItem!.asset.duration.seconds
                    self.maxLbl.text = getHoursMinutesSecondsFrom(seconds: duration)
                    self.progressView.progress = Float((currentTime * 100)/duration)/100.0
                }
            }
        }else {
            playBackView.isHidden = true
            videoBackView.isHidden = false
            
            if let videoID = selectedRequest.track_link.components(separatedBy: "=").last {
                print(videoID)
                videoBackView.loadVideoID(videoID)
                videoBackView.play()
            }
            
            let videoURL : String = (selectedRequest.track_link)
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
    
    //MARK:- Slider delegate method
    @IBAction func valueChange(_ sender: myCustomSlider) {
      //  sender.label.text = String(Int(sender.value))
        sender.labelText = { String(Int(sender.value)) }
    }
    
    //MARK:- Button click event
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
    
    
    @IBAction func clickToSubmit(_ sender: Any) {
        
        if feedbackTxt.text?.trimmed == "" {
            displayToast("Please enter feedback message")
        }else {
            var param : [String : Any] = [String :Any]()
            param["feedback_id"] = selectedRequest.feedback_id
            param["ratting"] = Int(slider.value)
            param["message"] = feedbackTxt.text
            
            APIManager.shared.serviceCallToGiveFeedback(param) {
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_FEEDBACK_REQUEST_DATA), object: self.selectedRequest.dictionary())
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

}


public class myCustomSlider: UISlider {
    
    var label: UILabel
    var labelXMin: CGFloat?
    var labelXMax: CGFloat?
    var labelText: () -> String = { "" }
    
    required public init?(coder aDecoder: NSCoder) {
        label = UILabel()
        super.init(coder: aDecoder)!
        self.addTarget(self, action: #selector(onValueChanged(sender:)), for: .valueChanged)
    }
    
    func setup() {
        labelXMin = frame.origin.x + 16
        labelXMax = frame.origin.x + self.frame.width - 14
        let labelXOffset: CGFloat = labelXMax! - labelXMin!
        let valueOffset: CGFloat = CGFloat(self.maximumValue - self.minimumValue)
        let valueDifference: CGFloat = CGFloat(self.value - self.minimumValue)
        let valueRatio: CGFloat = CGFloat(valueDifference/valueOffset)
        let labelXPos = CGFloat(labelXOffset*valueRatio + labelXMin!)
        label.frame = CGRect(x: labelXPos, y: self.frame.origin.y - 25, width: 200, height: 25)
        label.text = String(format: "%.1f", value)//self.value.description
        self.superview!.addSubview(label)
    }
    
    func updateLabel() {
        label.text = String(format: "%.1f", value)//labelText()
        let labelXOffset: CGFloat = labelXMax! - labelXMin!
        let valueOffset: CGFloat = CGFloat(self.maximumValue - self.minimumValue)
        let valueDifference: CGFloat = CGFloat(self.value - self.minimumValue)
        let valueRatio: CGFloat = CGFloat(valueDifference/valueOffset)
        let labelXPos = CGFloat(labelXOffset*valueRatio + labelXMin!)
        label.frame = CGRect(x: labelXPos - label.frame.width/2, y: self.frame.origin.y - 25, width: 200, height: 25)
        label.textAlignment = NSTextAlignment.center
        label.textColor = GreenColor
        label.font = UIFont(name: SFUI_SEMIBOLD, size: 16)
        self.superview!.addSubview(label)
    }
    
    public override func layoutSubviews() {
        labelText = { self.value.description }
       
        setup()
        updateLabel()
        super.layoutSubviews()
    }
    
    @objc func onValueChanged(sender: myCustomSlider) {
        updateLabel()
    }
}
