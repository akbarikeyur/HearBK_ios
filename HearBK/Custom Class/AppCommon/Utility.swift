//
//  Utility.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import UIKit
import Toaster
import AVFoundation
import SKPhotoBrowser

struct PLATFORM {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

//MARK:- Image Function
func compressImage(_ image: UIImage, to toSize: CGSize) -> UIImage {
    var actualHeight: Float = Float(image.size.height)
    var actualWidth: Float = Float(image.size.width)
    let maxHeight: Float = Float(toSize.height)
    //600.0;
    let maxWidth: Float = Float(toSize.width)
    //800.0;
    var imgRatio: Float = actualWidth / actualHeight
    let maxRatio: Float = maxWidth / maxHeight
    //50 percent compression
    if actualHeight > maxHeight || actualWidth > maxWidth {
        if imgRatio < maxRatio {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight
            actualWidth = imgRatio * actualWidth
            actualHeight = maxHeight
        }
        else if imgRatio > maxRatio {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth
            actualHeight = imgRatio * actualHeight
            actualWidth = maxWidth
        }
        else {
            actualHeight = maxHeight
            actualWidth = maxWidth
        }
    }
    let rect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(actualWidth), height: CGFloat(actualHeight))
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    let imageData1: Data? = UIImageJPEGRepresentation(img!, CGFloat(1.0))
    UIGraphicsEndImageContext()
    return  imageData1 == nil ? image : UIImage(data: imageData1!)!
}

//MARK:- UI Function
func getTableBackgroundViewForNoData(_ str:String, size:CGSize) -> UIView{
    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    noDataLabel.text          = str.decoded
    noDataLabel.textColor     = ColorType.DarkGray.value
    //noDataLabel.font          = Regular18Font
    noDataLabel.textAlignment = .center
    return noDataLabel
}
func showCreditFormattedStr(_ credit:Int?) -> String{
    if(credit == nil){
        return "$0"
    }
    else{
        return "$" + String(credit!)
    }
}

func showEmailFormattedStr(_ str:String) -> String{
    let  arr:[String] = str.components(separatedBy: "@")
    if(arr.count == 2){
        if(arr[0].count > 2){
            return arr[0][0] + "***" + arr[0][arr[0].count-1] + arr[1]
        }
        else{
            return str
        }
    }
    return str
}


//MARK:- Toast
func displayToast(_ message:String)
{
   // showAlert("", message: NSLocalizedString(message, comment: ""),completion: {
   // })
    let toast = Toast(text: NSLocalizedString(message, comment: ""))
    toast.show()
}

func showLoader()
{
    AppDelegate().sharedDelegate().showLoader()
}
func removeLoader()
{
    AppDelegate().sharedDelegate().removeLoader()
}
func showAlertWithOption(_ title:String, message:String, btns:[String] = ["Yes", "Cancel"],completionConfirm: @escaping () -> Void,completionCancel: @escaping () -> Void){
    let myAlert = UIAlertController(title:NSLocalizedString(title, comment: ""), message:NSLocalizedString(message, comment: ""), preferredStyle: UIAlertControllerStyle.alert)
    let rightBtn = UIAlertAction(title: btns[0], style: UIAlertActionStyle.default, handler: { (action) in
        completionConfirm()
    })
    let leftBtn = UIAlertAction(title: btns[1], style: UIAlertActionStyle.cancel, handler: { (action) in
        completionCancel()
    })
    myAlert.addAction(rightBtn)
    myAlert.addAction(leftBtn)
    AppDelegate().sharedDelegate().window?.rootViewController?.present(myAlert, animated: true, completion: nil)
}

func showAlert(_ title:String, message:String, completion: @escaping () -> Void) {
    let myAlert = UIAlertController(title:NSLocalizedString(title, comment: ""), message:NSLocalizedString(message, comment: ""), preferredStyle: UIAlertControllerStyle.alert)
    myAlert.view.tintColor = GreenColor
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:{ (action) in
        completion()
    })
    myAlert.addAction(okAction)
    AppDelegate().sharedDelegate().window?.rootViewController?.present(myAlert, animated: true, completion: nil)
}

func displaySubViewtoParentView(_ parentview: UIView! , subview: UIView!)
{
    subview.translatesAutoresizingMaskIntoConstraints = false
    parentview.addSubview(subview);
    parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: parentview, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0))
    parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: parentview, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
    parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: parentview, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
    parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: parentview, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
    parentview.layoutIfNeeded()
}

func displaySubViewWithScaleOutAnim(_ view:UIView){
    view.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
    view.alpha = 1
    UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.55, initialSpringVelocity: 1.0, options: [], animations: {() -> Void in
        view.transform = CGAffineTransform.identity
    }, completion: {(_ finished: Bool) -> Void in
    })
}
func displaySubViewWithScaleInAnim(_ view:UIView){
    UIView.animate(withDuration: 0.25, animations: {() -> Void in
        view.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        view.alpha = 0.0
    }, completion: {(_ finished: Bool) -> Void in
        view.removeFromSuperview()
    })
}

func displaySubViewWithFade(_ view:UIView){
    view.alpha = 0
    UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.55, initialSpringVelocity: 1.0, options: [], animations: {() -> Void in
        view.alpha = 1
    }, completion: {(_ finished: Bool) -> Void in
    })
}

//MARK:- Open Url
func opwnUrlInSafari(strUrl : String)
{
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(URL(string : strUrl)!, options: [:]) { (isOpen) in
            
        }
    } else {
        // Fallback on earlier versions
    }
}

//MARK:- Color function
func colorFromHex(hex : String) -> UIColor
{
    return colorWithHexString(hex, alpha: 1.0)
}

func colorFromHex(hex : String, alpha:CGFloat) -> UIColor
{
    return colorWithHexString(hex, alpha: alpha)
}

func colorWithHexString(_ stringToConvert:String, alpha:CGFloat) -> UIColor {
    
    var cString:String = stringToConvert.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: alpha
    )
}

func imageFromColor(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    
    let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
}

//MARK : - Add Credit Card
func showCardNumberFormattedStr(_ str:String, isRedacted:Bool = true) -> String{

    let tempStr:String = sendDetailByRemovingChar(sendDetailByRemovingChar(str, char:"-"), char: " ")
    var retStr:String = ""
    for i in 0..<tempStr.count{
        if(i == 4 || i == 8 || i == 12){
            retStr += "-"
        }
        retStr += tempStr[i]
    }
    if(isRedacted){
        var arr:[String] = retStr.components(separatedBy: "-")
        for i in 0..<arr.count{
            if(i == 1 || i == 2){
                arr[i] = "xxxx"
            }
        }
        retStr = arr.joined(separator: "-")
    }
    return retStr
}
func showCardExpDateFormattedStr(_ str:String) -> String{

    let tempStr:String = sendDetailByRemovingChar(str, char:"/")
    var retStr:String = ""
    for i in 0..<tempStr.count{
        if(i == 2){
            retStr += "/"
        }
        retStr += tempStr[i]
    }
    return retStr
}

//MARK:- Mobile Format



func sendDetailByRemovingChar(_ str:String, char:String = " ") -> String{
    let regExp :String = char + "\n\t\r"
    return String(str.filter { !(regExp.contains($0))})
}

func sendDetailByRemovingChar(_ attrStr:NSAttributedString, char:String = " ") -> String{
    let str:String = attrStr.string
    let regExp :String = char + "\n\t\r"
    return String(str.filter { !(regExp.contains($0))})
}


//MARK:- Delay Features
func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}


//MARK: - Local save
func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func storeImageInDocumentDirectory(image : UIImage, imageName : String)
{
    let imgName = imageName + ".png"
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imgName)
    //print(paths)
    let imageData = UIImagePNGRepresentation(image)
    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
}

func getImage(imageName : String) -> UIImage?
{
    let imgName = imageName + ".png"
    let fileManager = FileManager.default
    let imagePAth = (getDirectoryPath() as NSString).appendingPathComponent(imgName)
    if fileManager.fileExists(atPath: imagePAth){
        return UIImage(contentsOfFile: imagePAth)!
    }else{
        return nil
    }
}

func deleteImage(fromDirectory imageName: String) -> Bool {
    if imageName.count == 0 {
        return true
    }
    let imgName = imageName + (".png")
    let fileManager = FileManager.default
    
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imgName)
    
    if fileManager.fileExists(atPath: paths){
        try! fileManager.removeItem(atPath: paths)
        return true
    }else{
        print("Something wronge.")
        return false
    }
}

func deleteFileFromDirectory(filePath : String)
{
    let fileManager = FileManager.default
    
    if fileManager.fileExists(atPath: filePath){
        try! fileManager.removeItem(atPath: filePath)
    }else{
        print("Something wronge.")
    }
}

func storeVideoInDocumentDirectory(videoUrl : URL, videoName : String)
{
    let video_name = videoName + ".mp4"
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(video_name)
    //print(paths)
    let videoData = try? Data(contentsOf: videoUrl)
    fileManager.createFile(atPath: paths as String, contents: videoData, attributes: nil)
}

func getVideo(videoName : String) -> String?
{
    let video_name = videoName + ".mp4"
    let fileManager = FileManager.default
    let videoPAth = (getDirectoryPath() as NSString).appendingPathComponent(video_name)
    if fileManager.fileExists(atPath: videoPAth){
        return videoPAth
    }else{
        return nil
    }
}

func deleteVideo(fromDirectory videoName: String) -> Bool {
    if videoName.count == 0 {
        return true
    }
    let video_Name = videoName + (".mp4")
    let fileManager = FileManager.default
    
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(video_Name)
    
    if fileManager.fileExists(atPath: paths){
        try! fileManager.removeItem(atPath: paths)
        return true
    }else{
        print("Something wronge.")
        return false
    }
}

// Get Video ID from URL
func extractYoutubeIdFromLink(link: String) -> String? {
    let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
    guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
        return nil
    }
    let nsLink = link as NSString
    let options = NSRegularExpression.MatchingOptions(rawValue: 0)
    let range = NSRange(location: 0, length: nsLink.length)
    let matches = regExp.matches(in: link as String, options:options, range:range)
    if let firstMatch = matches.first {
        return nsLink.substring(with: firstMatch.range)
    }
    return nil
}


//CRATE THUMBNAIL
func getThumbnailFrom(path: String, btn : UIButton) {
    do {
        let asset = AVURLAsset(url: URL(string: path)! , options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)
        btn.setBackgroundImage(thumbnail, for: .normal)
//        return thumbnail
    } catch let error {
        
        print("*** Error generating thumbnail: \(error.localizedDescription)")
    }
}

//MARK : - SKPhotoBrowser
func displayFullImage(_ photos : [String],_ index : Int)
{
    // 1. create URL Array
    var images = [SKPhoto]()
    for i in 0..<photos.count
    {
        if let newImg = AppModel.shared.ImageQueue[photos[i]] as? UIImage{
            let img = SKPhoto.photoWithImage(newImg)
            img.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
            images.append(img)
        }
        else
        {
            let photo = SKPhoto.photoWithImageURL(photos[i])
            photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
            images.append(photo)
        }
    }


    // 2. create PhotoBrowser Instance, and present.
    let browser = SKPhotoBrowser(photos: images)
    browser.initializePageIndex(index)
    UIApplication.topViewController()?.present(browser, animated: true, completion: {})
}

func displayPriceWithCurrency(_ price : Float) -> String
{
    let strPrice : String = String(format: "%0.2f", price)
    return "$" + strPrice
}

func setFlotingRating(_ rate : Double) -> String
{
    var strRate : String = String(format: "%0.2f", rate)
//    if strRate.contains(".0")
//    {
//        strRate = strRate.replacingOccurrences(of: ".0", with: "")
//    }
    return strRate
}

func getMonthArray() -> [String]
{
    var monthArr : [String] = [String]()
    for i in 1...12
    {
        monthArr.append(String(i))
    }
    return monthArr
}

func getCardYearArray() -> [String]
{
    var yearArr : [String] = [String]()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY"
    let currentYear = dateFormatter.string(from: Date())
    
    for i in 0...30
    {
        yearArr.append(String(Int(currentYear)! + i))
    }
    return yearArr
}


//MARK :- App Method
func addExtraSpaceInTag(_ strTag : String) -> String
{
    return "   " + strTag + "   "
}

func getAddressString(_ city : String, _ state : String, _ country : String) -> String
{
    var address : String = ""
    if city.trimmed != ""
    {
        address = city.trimmed
    }
    if state.trimmed != ""
    {
        if address.count > 0
        {
            address = address + ", "
        }
        address = address + state.trimmed
    }
    if country.trimmed != ""
    {
        if address.count > 0
        {
            address = address + ", "
        }
        address = address + country.trimmed
    }
    return address
}

func getYoutubeId(youtubeUrl: String) -> Bool {
    if let value = URLComponents(string: youtubeUrl.trimmed)?.queryItems?.first(where: { $0.name == "v" })?.value, value != ""
    {
        return true
    }
    return false
}

func getHoursMinutesSecondsFrom(seconds: Double) -> String {
    let secs = Int(seconds)
    let hours = (secs / 3600)
    let minutes = (secs % 3600) / 60
    let seconds = (secs % 3600) % 60
    
    var minString : String = String(minutes)
    if minString.count == 1
    {
        minString = "0" + minString
    }
    var secString : String = String(seconds)
    if secString.count == 1
    {
        secString = "0" + secString
    }
    
    return minString + ":" + secString
}
