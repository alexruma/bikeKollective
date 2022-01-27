import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
<<<<<<< Updated upstream
    GMSServices.provideAPIKey("Your KEy HEre")
=======
    GMSServices.provideAPIKey("AIzaSyA6ghlPOg6Umn-i8pXNQ2GUpGL3lgZbGWU")
>>>>>>> Stashed changes
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
