import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Call the superclass implementation to execute the existing functionality
        let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Add additional functionality here
        GMSServices.provideAPIKey("AIzaSyD4-bLyOjZB1wZj7lnYXOd9fzJYOiaHoUI")
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        
        GeneratedPluginRegistrant.register(with: self)
        
        return result
    }
}
