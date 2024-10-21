import Flutter
import UIKit
import GoogleMaps
import Firebase
// import kakao_flutter_sdk_common

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Firebase 초기화
    FirebaseApp.configure()
    
    // Google Maps API 키 추가
    GMSServices.provideAPIKey("AIzaSyDIBovNEZWIZSPVyRmzmBaCsInU8YgQPHc")
    
    // Kakao 플러그인 수동 등록
    //SwiftKakaoFlutterSdkPlugin.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
