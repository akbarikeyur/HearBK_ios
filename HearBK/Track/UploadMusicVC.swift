//
//  UploadMusicVC.swift
//  HearBK
//
//  Created by PC on 02/02/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit
import IQMediaPickerController
import MediaPlayer

class UploadMusicVC: UIViewController, UITextFieldDelegate, IQMediaPickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var audioBtn: Button!
    @IBOutlet weak var videoBtn: Button!
    @IBOutlet weak var uploadTxt: TextField!
    @IBOutlet weak var uploadBtn: Button!
    @IBOutlet weak var uploadBtnWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var titleTxt: TextField!
    @IBOutlet weak var descriptionTxt: TextField!
    @IBOutlet weak var peopleProfileBtn1: Button!
    @IBOutlet weak var peopleProfileBtn2: Button!
    @IBOutlet weak var peopleProfileBtn3: Button!
    @IBOutlet weak var peopleProfileBtn4: Button!
    @IBOutlet weak var peopleProfileBtn5: Button!
    
    @IBOutlet weak var selectedPeopleTotalLbl: Label!
    @IBOutlet weak var totalPriceLbl: Label!
    
    @IBOutlet var profileView: View!
    @IBOutlet var loginview: UIView!
    
    @IBOutlet var profileImgBtn: Button!
    @IBOutlet var nameLbl: Label!
    @IBOutlet var emailLbl: Label!
    
    @IBOutlet var fileSizeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var fileSizeView: View!
    
    var selectedMedias : IQMediaPickerSelection?
    var isAudioUpload = true
    var selectTrack : String = "audio"
    var price : Float = 0.0
    var arrSelectedListener : [UserModel] = [UserModel]()
    
    var AudioFileData : Data = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateUserDetail), name: NSNotification.Name.init(NOTIFICATION.SELECTED_LISTENER), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrentUserData), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        
        audioBtn.isSelected = true
        uploadTxt.isUserInteractionEnabled = false
        
        appListenerSetup()
        
        if isUserLogin() {
            profileView.isHidden = false
            loginview.isHidden = true
            nameLbl.text = AppModel.shared.currentUser.display_name
            emailLbl.text = AppModel.shared.currentUser.email
            AppDelegate().sharedDelegate().setUserBackgroundImage(profileImgBtn, AppModel.shared.currentUser.avatar)
            
        } else {
            profileView.isHidden = true
            loginview.isHidden = false
        }
        
        for item in arrSelectedListener {
            price += Float(item.price)
        }
        totalPriceLbl.text =  displayPriceWithCurrency(price)
    }
    
    // handle notification
    @objc func updateUserDetail(notification: NSNotification) {
        let dict = notification.object as! [UserModel]
        arrSelectedListener = dict
        appListenerSetup()
        price = 0.0
        for item in arrSelectedListener {
            price += Float(item.price)
        }
        totalPriceLbl.text =  displayPriceWithCurrency(price)
    }
    
    @objc func updateCurrentUserData()
    {
        if isUserLogin() {
            profileView.isHidden = false
            loginview.isHidden = true
            nameLbl.text = AppModel.shared.currentUser.display_name
            emailLbl.text = AppModel.shared.currentUser.email
            AppDelegate().sharedDelegate().setUserBackgroundImage(profileImgBtn, AppModel.shared.currentUser.avatar)
            
        } else {
            profileView.isHidden = true
            loginview.isHidden = false
        }
        
        let index = arrSelectedListener.firstIndex { (temp) -> Bool in
            temp.uId == AppModel.shared.currentUser.uId
        }
        if index != nil
        {
            arrSelectedListener.remove(at: index!)
            appListenerSetup()
            price = 0.0
            for item in arrSelectedListener {
                price += Float(item.price)
            }
            totalPriceLbl.text =  displayPriceWithCurrency(price)
        }
        
    }
    
    //MARK:- Set UIDesigning
    func appListenerSetup() {
        peopleProfileBtn1.isHidden = true
        peopleProfileBtn2.isHidden = true
        peopleProfileBtn3.isHidden = true
        peopleProfileBtn4.isHidden = true
        peopleProfileBtn5.isHidden = true
        
        selectedPeopleTotalLbl.isHidden = true
        
        if arrSelectedListener.count > 0 {
            peopleProfileBtn1.isHidden = false
            AppDelegate().sharedDelegate().setUserBackgroundImage(peopleProfileBtn1, arrSelectedListener[0].avatar)
            
            if arrSelectedListener.count > 1 {
                peopleProfileBtn2.isHidden = false
                AppDelegate().sharedDelegate().setUserBackgroundImage(peopleProfileBtn2, arrSelectedListener[1].avatar)
                
                if arrSelectedListener.count > 2 {
                    peopleProfileBtn3.isHidden = false
                    AppDelegate().sharedDelegate().setUserBackgroundImage(peopleProfileBtn3, arrSelectedListener[2].avatar)
                    
                    if arrSelectedListener.count > 3 {
                        peopleProfileBtn4.isHidden = false
                        AppDelegate().sharedDelegate().setUserBackgroundImage(peopleProfileBtn4, arrSelectedListener[3].avatar)
                        
                        if arrSelectedListener.count > 4 {
                            peopleProfileBtn5.isHidden = false
                            AppDelegate().sharedDelegate().setUserBackgroundImage(peopleProfileBtn5, arrSelectedListener[4].avatar)
                            
                            if arrSelectedListener.count > 5 {
                                selectedPeopleTotalLbl.isHidden = false
                                selectedPeopleTotalLbl.text = "+" + String(arrSelectedListener.count - 5)
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    // MARK:- Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToNext(_ sender: Any) {
        self.view.endEditing(true)
        if !isUserLogin()
        {
            displayToast("In order to upload track, please login or create an account!")
            return
        }
        
        if selectTrack == "video" && extractYoutubeIdFromLink(link : uploadTxt.text!) == nil {
            displayToast("Invalid link.")
        }
        else if selectTrack == "audio" && (uploadTxt.text?.trimmed == "" || AudioFileData.count == 0) {
            displayToast("Please add your track.")
        }
        else if titleTxt.text?.trimmed == "" {
            displayToast("Please enter your track title.")
        }
        else if descriptionTxt.text?.trimmed == "" {
            displayToast("Please enter about track.")
        }
        else if arrSelectedListener.count == 0 {
            displayToast("Please select Listener")
        }
        else
        {
            var param : [String : Any] = [String : Any]()
            param["track_title"] = titleTxt.text?.trimmed
            param["track_description"] = descriptionTxt.text?.trimmed
            param["music_type"] = selectTrack

            if selectTrack == "video" {
                param["track_link"] = uploadTxt.text
            }
            
            var arrTemp : [String] = [String]()
            for temp in arrSelectedListener
            {
                arrTemp.append(temp.uId)
            }
            param["listner_ids"] = arrTemp.joined(separator: ",")
            print(param)
            
            let vc : FundHBKAccountVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "FundHBKAccountVC") as! FundHBKAccountVC
            vc.param = param
            vc.total = totalPriceLbl.text!
            
            if selectTrack.lowercased() == "audio" {
                vc.audioData = AudioFileData
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func clickToMusic(_ sender: UIButton) {
        self.view.endEditing(true)
        resetGenderButton()
        sender.isSelected = true
        
        switch sender.tag{
        case 1: // Audio
            fileSizeViewHeightConstraint.constant = 40
            uploadTxt.isUserInteractionEnabled = false
            fileSizeView.isHidden = false
            isAudioUpload = true
            uploadTxt.text = ""
            selectTrack = "audio"
            uploadTxt.placeholderColorString = "No files uploaded"
            uploadBtn.setTitle("Upload", for: .normal)
            uploadBtn.setImage(nil, for: .normal)
            uploadBtnWidthConstant.constant = 60
            break
            
        case 2: // Video
            isAudioUpload = false
            uploadTxt.isUserInteractionEnabled = true
            fileSizeViewHeightConstraint.constant = 0
            fileSizeView.isHidden = true
            uploadTxt.text = ""
            if PLATFORM.isSimulator
            {
                uploadTxt.text = "https://www.youtube.com/watch?v=FdBGj19-mGQ&t=81s"
            }
            selectTrack = "video"
            uploadTxt.placeholderColorString = "Paste youtube link"
            uploadBtn.setTitle("Paste", for: .normal)
            uploadBtn.setImage(nil, for: .normal)
            uploadBtnWidthConstant.constant = 60
            break
            
        default:
            break
        }
        
    }
    
    @IBAction func clickToUpload(_ sender: UIButton) {
        self.view.endEditing(true)
        uploadBtnWidthConstant.constant = 60
        if sender.title(for: .normal) == "Upload" {
            showMediaPicker()
         }
        else if sender.title(for: .normal) == "Paste" {
            uploadTxt.text = UIPasteboard.general.string
        } else {
            uploadTxt.text = ""
            uploadBtn.setImage(nil, for: .normal)
            if isAudioUpload {
                uploadBtn.setTitle("Upload", for: .normal)
            }
            else {
                uploadBtn.setTitle("Paste", for: .normal)
            }
        }
    }
    
    @IBAction func clickToSeeAll(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc : SearchPeopleVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SearchPeopleVC") as! SearchPeopleVC
        vc.arrSelectedData = arrSelectedListener
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToCreateAccount(_ sender: Any) {
        self.view.endEditing(true)
        let vc : SignUpVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        vc.screenType = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToLogIn(_ sender: Any) {
        self.view.endEditing(true)
        let vc : LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.screenType = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Media Picker
    func showMediaPicker()
    {
        let controller : IQMediaPickerController = IQMediaPickerController()
        controller.delegate = self
        controller.mediaTypes = [3]
        self.present(controller, animated: true, completion: nil)
    }
    
    func mediaPickerController(_ controller: IQMediaPickerController, didFinishMedias selection: IQMediaPickerSelection) {
        showLoader()
        selectedMedias = IQMediaPickerSelection()
        selectedMedias = selection
        let item : MPMediaItem = selectedMedias!.selectedAudios[0];
        let url : URL = item.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
        
        let songAsset : AVURLAsset = AVURLAsset(url: url)
        let exporter : AVAssetExportSession = AVAssetExportSession(asset: songAsset, presetName: AVAssetExportPresetPassthrough)!
        exporter.outputFileType = AVFileType(rawValue: "com.apple.quicktime-movie")
        
        if item.albumTitle != ""
        {
            self.uploadTxt.text = item.albumTitle
        }
        else if item.artist != ""
        {
            self.uploadTxt.text = item.artist
        }
        
        let audioName1 = getCurrentTimeStampValue()
        
        let path : String = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(audioName1)
        
        let exportURL : URL = URL(fileURLWithPath: path)
        exporter.outputURL = exportURL
        
        exporter.exportAsynchronously {
            
            switch exporter.status {
            case AVAssetExportSessionStatus.failed:
                print((exporter.error?.localizedDescription)!)
                break
            case AVAssetExportSessionStatus.completed:
                do {
                    self.AudioFileData = try Data(contentsOf: exportURL)
                    print(self.AudioFileData.count)
                    
                    if self.AudioFileData.count > (1024*1024*10)
                    {
                        displayToast("Please select less then 10MB file")
                        self.selectedMedias = nil
                        self.uploadTxt.text = ""
                        self.AudioFileData = Data()
                        
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                break
            default:
                break
            }
            removeLoader()
        }
        
    }
    
    func mediaPickerControllerDidCancel(_ controller: IQMediaPickerController) {
        
    }
    
    // MARK:- Methods
    func resetGenderButton() {
        audioBtn.isSelected = false
        videoBtn.isSelected = false
    }
    
    //MARK:- UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == uploadTxt {
            let currentText = uploadTxt.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let changedText = currentText.replacingCharacters(in: stringRange, with: string)
            if isAudioUpload {
                if(changedText.length() > 0) {
                    uploadBtn.setTitle("", for: .normal)
                    uploadBtn.setImage(UIImage.init(named: "cancel"), for: .normal)
                    uploadBtnWidthConstant.constant = 20
                } else {
                    uploadBtn.setTitle("Upload", for: .normal)
                    uploadBtn.setImage(nil, for: .normal)
                    uploadBtnWidthConstant.constant = 60
                }
            }
            else {
                if(changedText.length() > 0) {
                    uploadBtn.setTitle("", for: .normal)
                    uploadBtn.setImage(UIImage.init(named: "cancel"), for: .normal)
                    uploadBtnWidthConstant.constant = 20
                } else {
                    uploadBtn.setTitle("Paste", for: .normal)
                    uploadBtn.setImage(nil, for: .normal)
                    uploadBtnWidthConstant.constant = 60
                }
            }
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
