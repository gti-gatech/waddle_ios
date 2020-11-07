//
//  AppDelegate.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 01/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import GoogleMaps
import IQKeyboardManager
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var apnsToken = "devicetoken"
    var isFromNotification = false
    var isFromBackground = false
    var notificationData: [String: Any]?
    var isNotificationClicked = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyBdeW3UY7Uw3kmWhv32Sw8ucCUOn9gW9ik")
        //Remote Notification Info
        UNUserNotificationCenter.current().delegate = self
          let remoteNotifiInfo = launchOptions?[.remoteNotification] as? [AnyHashable : Any]

          //Accept push notification when app is not open
          if let remoteNotifiInfo = remoteNotifiInfo, UIApplication.shared.applicationState == .background {
              self.application(application, didReceiveRemoteNotification: remoteNotifiInfo)
          }
        IQKeyboardManager.shared().isEnabled = true
        Services.initWebServicesEnvironment(.staging)
        registerForRemoteNotification()
        let _ = LocationService.sharedInstance
        return true
    }
}

extension AppDelegate {
    
    static var sharedInstance: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func checkIfUserLoggedIn() {
        if let _ = CommonFunctions.getUserDetailFromUserDefault() {
            setupTabBarAsRoot()
        }
    }
    
    func setupTabBarAsRoot() {
        let tabBar : CustomTabBarController = storyboardDashBoard.instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }
    
    func setupLoginAsRoot() {
        let login : LoginSignUpVC = storyboardMain.instantiateViewController(withIdentifier: "LoginSignUpVC") as! LoginSignUpVC
        
        let nav = UINavigationController(rootViewController: login)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerForRemoteNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                UNUserNotificationCenter.current().delegate = self
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        apnsToken = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications: \(error.localizedDescription)")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard let aps = userInfo["aps"] as? [String: Any] else {return}
        print("Received push notification: \(userInfo)")
        print("\(aps)")
        self.isFromNotification = true
        self.isFromBackground = (UIApplication.shared.applicationState == .active) ? true :  false
        self.notificationData = aps
        if (aps["type"] as? String ?? "") == NotificationType.newMessage.rawValue{
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                guard let tabbar = UIApplication.shared.windows.first?.rootViewController as? CustomTabBarController else{ return }
                tabbar.selectedIndex = 4
            }
        }else{
            NotificationsVC.navigateFromNotificationToNotificationVC()
        }
        completionHandler()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        print("Received push notification: \(userInfo)")
//        let aps = userInfo["aps"] as! [String: Any]
//        print("\(aps)")
//        self.isFromNotification = true
//        self.isFromBackground = (UIApplication.shared.applicationState == .active) ? true :  false
//        self.notificationData = aps
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
//            self.setupTabBarAsRoot()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
//            if UIApplication.shared.applicationState == .active {
//                if self.getVisibleViewController(self.window?.rootViewController) is ChatsVC {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
//                        self.setupTabBarAsRoot()
//                    }
//                }
//            } else  {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
//                    self.setupTabBarAsRoot()
//                }
//            }
//        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        completionHandler([.alert, .badge, .sound])
    }
    
    func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        
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
    
}

