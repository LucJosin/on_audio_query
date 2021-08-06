import Flutter
import UIKit
import MediaPlayer

public class SwiftOnAudioQueryPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.lucasjosino.on_audio_query", binaryMessenger: registrar.messenger())
    let instance = SwiftOnAudioQueryPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "permissionsStatus":
            let permissionStatus = MPMediaLibrary.authorizationStatus()
            if permissionStatus == MPMediaLibraryAuthorizationStatus.authorized {
                result(true)
            } else {
                result(false)
            }
        case "permissionsRequest":
            MPMediaLibrary.requestAuthorization { status in
                if (status == .authorized) {
                    result(true)
                } else {
                    result(false)
                }
            }
        case "queryDeviceInfo":
            queryDeviceInfo(result: result)
        default:
            OnAudioController(call: call, result: result).chooseMethod()
        }
      }
}
