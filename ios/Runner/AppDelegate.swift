import UIKit
import Flutter
import GoogleMaps
import NaverThirdPartyLogin

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAcFH0RxG1lD5jBA6voMl4MvKOCdB5zYg8")
    GeneratedPluginRegistrant.register(with: self)

    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    naverLoginInstance?.isNaverAppOauthEnable = true
    naverLoginInstance?.isInAppOauthEnable = true
    naverLoginInstance?.serviceUrlScheme = "ssoupurlscheme"
    naverLoginInstance?.consumerKey = "jSSDX9vyG5t_3htQlW73"
    naverLoginInstance?.consumerSecret = "L0VKXGZxWq"
    naverLoginInstance?.appName = "ssoup"

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    var applicationResult = false

    if (!applicationResult) {
       applicationResult = NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
    }

    if (!applicationResult) {
       applicationResult = super.application(app, open: url, options: options)
    }

    return applicationResult
  }
}
