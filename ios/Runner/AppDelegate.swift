import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  var iflytekPlugin: IflytekPlugin?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.example.flutter_getx_dio_scaffold/iflytek",
                                              binaryMessenger: controller.binaryMessenger)
    
    iflytekPlugin = IflytekPlugin(channel: channel)
    
    channel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      self.iflytekPlugin?.handle(call, result: result)
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
