import Flutter
import UIKit
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let crashChannel = FlutterMethodChannel(name: "crash_lab",
                                              binaryMessenger: controller.binaryMessenger)
    crashChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "forceUnwrap" {
        var bridge: FlutterViewController!
        // Triggers: unexpectedly found nil while unwrapping an Optional value
        bridge.viewDidLoad()
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
