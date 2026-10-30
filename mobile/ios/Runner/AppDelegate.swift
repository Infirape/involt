import Flutter
import UIKit

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
    registerStorageChannel(engineBridge.pluginRegistry)
  }

  /// Free space on the phone, for the low-storage warning.
  private func registerStorageChannel(_ registry: FlutterPluginRegistry) {
    guard let registrar = registry.registrar(forPlugin: "InvoltStorage") else { return }
    let channel = FlutterMethodChannel(name: "involt/storage", binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { call, result in
      guard call.method == "freeBytes" else {
        result(FlutterMethodNotImplemented)
        return
      }
      let home = URL(fileURLWithPath: NSHomeDirectory())
      let values = try? home.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
      result(values?.volumeAvailableCapacityForImportantUsage.map { Int($0) })
    }
  }
}
