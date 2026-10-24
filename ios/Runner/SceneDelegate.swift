import Flutter
import UIKit
import StripeCore  // StripeAPI.handleURLCallback lives in StripeCore, not StripePaymentSheet

class SceneDelegate: FlutterSceneDelegate {

  // Stripe payment helper channel — lets Dart call makeKeyAndVisible() right
  // before presenting the payment sheet, ensuring the FlutterViewController's
  // view is in the window hierarchy when stripe_ios tries to present on it.
  // Without this, UIKit logs "whose view is not in the window hierarchy" and
  // the payment sheet completion handler never fires → presentPaymentSheet hangs.
  private var stripeHelperChannel: FlutterMethodChannel?

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)

    // Register the Stripe helper channel as soon as the FlutterViewController exists.
    if let flutterVC = window?.rootViewController as? FlutterViewController {
      stripeHelperChannel = FlutterMethodChannel(
        name: "bottles_up/stripe_helper",
        binaryMessenger: flutterVC.binaryMessenger
      )
      stripeHelperChannel?.setMethodCallHandler { [weak self] call, result in
        if call.method == "prepareForPayment" {
          // Make the Flutter window key and bring it to the front so that
          // stripe_ios can find a view controller that is actually in the
          // window hierarchy when it calls presentViewController.
          self?.window?.makeKeyAndVisible()
          print("💳 [SceneDelegate] prepareForPayment: window made key and visible")
          result(true)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }

    // Cold-start deep link (3DS return URL on launch).
    if let url = connectionOptions.urlContexts.first?.url {
      print("🔗 [SceneDelegate] willConnectTo URL: \(url)")
      _ = StripeAPI.handleURLCallback(with: url)
    }
  }

  // Keep the window key whenever the scene becomes active.
  // This guards against any system event (CallKit, notification banner, etc.)
  // that temporarily steals key-window status from our Flutter window.
  override func sceneDidBecomeActive(_ scene: UIScene) {
    super.sceneDidBecomeActive(scene)
    window?.makeKeyAndVisible()
  }

  // Called when the app is already running and a URL opens it (e.g. 3DS redirect).
  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    super.scene(scene, openURLContexts: URLContexts)
    guard let url = URLContexts.first?.url else { return }
    print("🔗 [SceneDelegate] openURLContexts: \(url)")

    if StripeAPI.handleURLCallback(with: url) {
      print("💳 [SceneDelegate] URL handled by Stripe")
      return
    }

    if let flutterVC = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "app_links",
        binaryMessenger: flutterVC.binaryMessenger
      )
      channel.invokeMethod("onAppLink", arguments: url.absoluteString)
    }
    NotificationCenter.default.post(
      name: NSNotification.Name("com.llfbandit.app_links.deeplink"),
      object: nil,
      userInfo: ["url": url.absoluteString]
    )
  }
}
