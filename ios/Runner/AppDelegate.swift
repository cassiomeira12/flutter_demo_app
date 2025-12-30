import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let appName = Bundle.main.object(forInfoDictionaryKey: "app_name") as? String {
      print("App Name: \(appName)")
    }

    self.setupFlutter()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setupFlutter() {
    let controller = window?.rootViewController as! FlutterViewController
    FlutterHelper.shared.loadMethodChannel(controller: controller)
    GeneratedPluginRegistrant.register(with: self)
  }
}
