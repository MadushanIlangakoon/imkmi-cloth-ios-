//
//  AppDelegate.swift
//  ClothingStore-iOS
//
//  Created by Navin Thamindu on 2024-10-06.
//

import UIKit
import SwiftUI
import UserNotifications

// The AppDelegate class manages app lifecycle events and notification scheduling
//need to migrate notifications for notification manager

class AppDelegate: UIResponder, UIApplicationDelegate {
    var cartItems = GlobalVariables.globalCart // Store the cart items globally
    var window: UIWindow? // Window for the app UI
    
    
    
    
    // Schedule a notification to remind users about new deals every minute
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Don't Miss Out"
        content.body = "Did you forgot to check our latest deals!?"
        content.sound = UNNotificationSound.default
        // Trigger after 60 seconds and repeat
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: "receiveNews", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    
    
    
    // Schedule a reminder notification if cart items are added
    func scheduleFilledCart() {
        let content = UNMutableNotificationContent()
        content.title = "Oh oh!"
        content.body = "There are items in your cart. You might want to purchase them before its too late"
        content.sound = UNNotificationSound.default
        // Trigger after 3 seconds, no repeat
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "reminderNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    
    
    // This area called after the app has finished launching
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Perform any setup after launching the app
        
        
        // setting default notification preferences
        if UserDefaults.standard.object(forKey: "receiveReminders") == nil {
            UserDefaults.standard.set(true, forKey: "receiveReminders") // Default to true
        }
        
        if UserDefaults.standard.object(forKey: "receiveNews") == nil {
            UserDefaults.standard.set(true, forKey: "receiveNews") // Default to true
        }
        
        
        
        // Request permission for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification authorization granted")
                
                
            } else {
                print("Notification authorization denied")
            }
        }
        //if user has turned on the setting then they will recieve notification
        if (UserDefaults.standard.bool(forKey: "receiveReminders")){
            self.scheduleNotification()
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["reminderNotification"])
        }
        // Add observer for when app moves to the background
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        return true
    }
    
    // Called when the app is moved to background
    @objc func appMovedToBackground() {
        print("App moved to background!")
        cartItems = GlobalVariables.globalCart
        print(cartItems)
        // If cart is not empty and user has reminders enabled
        if (!cartItems.isEmpty && UserDefaults.standard.bool(forKey: "receiveReminders")) {
            print("Cart not empty")
            self.scheduleFilledCart()
        }
    }
    
    // Detect shake motion and post a notification
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            // Broadcast a notification when the device is shaken
            NotificationCenter.default.post(name: NSNotification.Name("DeviceShaken"), object: nil)
            print("DEBUG: Device shaken from appdelegate:motion ended")
        }
    }
}
