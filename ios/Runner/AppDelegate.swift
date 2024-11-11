import Flutter
import UIKit
import GoogleMaps
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase 초기화
    FirebaseApp.configure()
      
    // Google Maps API 키 추가
    GMSServices.setMetalRendererEnabled(true)
    GMSServices.provideAPIKey("AIzaSyDIBovNEZWIZSPVyRmzmBaCsInU8YgQPHc")

    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
