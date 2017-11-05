//
//  AppDelegate.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 23/10/17.
//  Last modified by Minh 04/11/17
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import UIKit
import CoreData
import fliclib
import Firebase
import UserNotifications

///////////////////////////////////////////////////////////////////
//                      Firebase iOS SDK                         //
//                  Author: Ricardo Aratani                      //
// Link: https://github.com/firebase/firebase-ios-sdk/issues/284 //
///////////////////////////////////////////////////////////////////

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate{
    
    var window: UIWindow?

    var ref: DatabaseReference!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController = sb.instantiateViewController(withIdentifier: "Onboarding")
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "onboardingComplete") {
            initialViewController = sb.instantiateViewController(withIdentifier: "MainApp")
        }
        
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        
        ref = Database.database().reference()
        
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //TODO: Handle foreground notification
        completionHandler([.alert])
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
   
        //How to get unique device ID in Swift
        //Author: Atomix
        //https://stackoverflow.com/questions/25925481/how-to-get-a-unique-device-id-in-swift
        //
        //How to read and write data on iOS
        //author: Firebase
        //https://firebase.google.com/docs/database/ios/read-and-write
        self.ref.child("users").child(UIDevice.current.identifierForVendor!.uuidString).setValue(["token" : fcmToken])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Assignment3_MON_Home")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        if ((SCLFlicManager.shared()?.handleOpen(url as URL))!) {
            return true
        }
        
        return false
    }

}

