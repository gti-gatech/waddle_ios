//
//  CommonFunctions.swift
//
//  Created by Krishna Datt Shukla on 6/6/16.
//  Copyright © 2016 Appzoro. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import MobileCoreServices
import AVFoundation
import Alamofire

@objc class CommonFunctions: NSObject {
    
    static func isNetworkReachable() -> Bool {
        if !NetworkReachabilityManager()!.isReachable {
            return false
        }
        return true
    }
    
    //mark: - NSUserDefault methods
    
    static func setUserDefaultFor(key : String?, value : Any?) {
        if key != nil && value != nil {
            let userDefaults : UserDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: key!)
            userDefaults.set(value, forKey: key!)
            userDefaults.synchronize()
        }
    }
    
    static func getUserDefaultFor(key : String) -> Any {
        let userDefaults : UserDefaults = UserDefaults.standard
        if ((userDefaults.object(forKey: key)) != nil) {
            return userDefaults.object(forKey: key)!
        }
        return "0"
    }
    
    static func setCornerRadiusOfViewWith(view: UIView, radius: Float, borderWidth: Float, borderColor: UIColor) {
        view.layer.cornerRadius = CGFloat(radius)
        view.layer.borderWidth = CGFloat(borderWidth)
        view.layer.borderColor = borderColor.cgColor
        view.layer.masksToBounds = true
    }
    
    //Mark: - Navigation bar methods
    
    static func setLeftBarButtonItemWith(image: UIImage, action: Selector, view: UIViewController)  {
        let barButton1 : UIBarButtonItem = UIBarButtonItem.init(image: image, style: UIBarButtonItem.Style.plain, target: view, action: action)
        barButton1.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        barButton1.setTitleTextAttributes([NSAttributedString.Key.font:  UIFont(name: "HelveticaNeue-Light", size: 18) ?? UIFont()], for: UIControl.State.normal);
        view.navigationItem.leftBarButtonItems = [barButton1]
    }
    static func setLeftBarButtonItemWith(title: String, action: Selector, view: UIViewController)  {
        let barButton1 : UIBarButtonItem = UIBarButtonItem.init(title: title, style: UIBarButtonItem.Style.plain, target: view, action: action)
        barButton1.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        barButton1.setTitleTextAttributes([NSAttributedString.Key.font:  UIFont(name: "HelveticaNeue-Light", size: 18) ?? UIFont()], for: UIControl.State.normal);
        view.navigationItem.rightBarButtonItems = [barButton1]
    }
    static func setRightBarButtonItemWith(image: UIImage, action: Selector, view: UIViewController)  {
        let barButton1 : UIBarButtonItem = UIBarButtonItem.init(image: image, style: UIBarButtonItem.Style.plain, target: view, action: action)
        barButton1.imageInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        view.navigationItem.rightBarButtonItems = [barButton1]
    }
    
    static func setRightBarButtonItemWith(title: String, action: Selector, view: UIViewController)  {
        let barButton1 : UIBarButtonItem = UIBarButtonItem.init(title: title, style: UIBarButtonItem.Style.plain, target: view, action: action)
        barButton1.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        barButton1.setTitleTextAttributes([NSAttributedString.Key.font:  UIFont(name: "HelveticaNeue-Light", size: 17) ?? UIFont()], for: UIControl.State.normal);
        view.navigationItem.rightBarButtonItems = [barButton1]
    }
    
    static func makeNavigationTransparent(navigationBar: UINavigationBar) {
        let transparentPixel = UIImage.init()
        navigationBar.setBackgroundImage(transparentPixel, for: UIBarMetrics.default)
        navigationBar.shadowImage = transparentPixel
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.isTranslucent = true
    }
    
    //MARK:- Alert View
    static func showAlertWithTitle(title:String, message:String, onViewController:UIViewController?, withButtonArray buttonArray:[String]? = [], dismissHandler:((_ buttonIndex:Int)->())?) -> Void {
        
        let alertController = UIAlertController(title: APP_NAME, message: message, preferredStyle: .alert)
        
        var ignoreButtonArray = false
        
        if buttonArray == nil
        {
            ignoreButtonArray = true
        }
        
        if !ignoreButtonArray
        {
            for item in buttonArray!
            {
                let action = UIAlertAction(title: item, style: .default, handler: { (action) in
                    
                    alertController.dismiss(animated: true, completion: nil)
                    
                    guard (dismissHandler != nil) else
                    {
                        return
                    }
                    dismissHandler!(buttonArray!.firstIndex(of: item)!)
                })
                alertController.addAction(action)
            }
        }
        
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: { (action) in
            
            guard (dismissHandler != nil) else
            {
                return
            }
            dismissHandler!(LONG_MAX)
        })
        alertController.addAction(action)
        
        onViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    static func removeObjectFromUserDefaultsFor(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func getPostTimeFor(datetime: String) -> String {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        df.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        let datePost: Date = df.date(from: datetime)!
        df.dateFormat = "dd MMM yyyy"
        let strTime: String = df.string(from: datePost)
        return strTime
    }
    
    static func getImage(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
    static func showHUD(controller: UIViewController) {
        MBProgressHUD.showAdded(to: controller.view, animated: true)
    }
    
    static func showHUDOnTop() {
        MBProgressHUD.showAdded(to: (getVisibleViewController(nil)?.view)!, animated: true)
    }
    
    static func hideHUD(controller: UIViewController) {
        MBProgressHUD.hide(for: controller.view, animated: true)
    }
    
    static func hideHUDFromTop() {
        MBProgressHUD.hide(for: (getVisibleViewController(nil)?.view)!, animated: true)
    }
    
    static func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    static func getDurationOfMediaFrom(url: URL) -> String {
        let asset = AVAsset(url: url)
        let duration = asset.duration
        let durationTime = CMTimeGetSeconds(duration)
        let seconds = Int(durationTime)
        let minutes = (seconds % 3600) / 60
        let sec = (seconds % 3600) % 60
        return String(format: "%@:%@", minutes < 10 ? "0\(minutes)" : "\(minutes)", sec < 10 ? "0\(sec)" : "\(sec)")
    }
    
    static func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {

        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }

        if rootVC?.presentedViewController == nil {
            return rootVC
        }

        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }

            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }

            return getVisibleViewController(presented)
        }
        return nil
    }
    static func saveUserDetailInUserDefault(data:loginData) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            UserDefaults.standard.set(encoded, forKey: USER_DETAILS)
        }
    }
    static func getUserDetailFromUserDefault() -> loginData? {
        if let savedPerson = UserDefaults.standard.object(forKey: USER_DETAILS) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(loginData.self, from: savedPerson) {
                return loadedPerson
            }
        }
        return nil
    }
}

