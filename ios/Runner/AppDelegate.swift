import Flutter
import UIKit

// Plugin registration for a full Flutter app that uses FlutterSceneDelegate.
// FlutterSceneDelegate.scene(_:willConnectTo:options:) creates the implicit engine;
// FlutterImplicitEngineDelegate.didInitializeImplicitFlutterEngine is then called
// so we can register plugins into the correct plugin registry.
@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
