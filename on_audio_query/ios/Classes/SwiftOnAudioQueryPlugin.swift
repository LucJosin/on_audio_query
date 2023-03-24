import Flutter
import UIKit

public class SwiftOnAudioQueryPlugin: NSObject, FlutterPlugin {
    private static let CHANNEL_NAME: String = "com.lucasjosino.on_audio_query"
    
    override public init() {
        Log.setLogLevel(level: .warning)
    }
    
    // Dart <-> Swift communication.
    public static func register(with registrar: FlutterPluginRegistrar) {
        Log.type.info("Called register")
        
        let channel = FlutterMethodChannel(
            name: "\(CHANNEL_NAME)",
            binaryMessenger: registrar.messenger()
        )
        let instance = SwiftOnAudioQueryPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        Log.type.debug("Started method call (\(call.method))")
        
        Log.type.info("Method call: \(call.method)")
        switch call.method {
        // This is a basic permission handler, will return [true] if has permission and
        // [false] if don't.
        //
        // The others status will be ignored and replaced with [false].
        case Method.PERMISSION_STATUS:
            result(PermissionController.checkPermission())
        // The same as [permissionStatus], this is a basic permission handler and will only
        // return [true] or [false].
        //
        // When adding the necessary [permissions] inside [Info.plist], [IOS] will automatically
        // request but, in any case, you can call this method.
        case Method.PERMISSION_REQUEST:
            result(PermissionController.requestPermission())
        // Some basic information about the platform, in this case, [IOS]
        //   * Model (Only return the "type", like: IPhone, MacOs, IPod..)
        //   * Version (IOS version)
        //   * Type (IOS)
        case Method.QUERY_DEVICE_INFO:
            let device = UIDevice.current
            result([
                "device_model": device.model,
                "device_sys_type": device.systemName,
                "device_sys_version": device.systemVersion,
            ])
        // Set logging level.
        case Method.SET_LOG_CONFIG:
            let args = call.arguments as! [String: Any]
            let level = args["level"] as! Int
            Log.setLogLevel(dartLevel: level)
            result(true)
        default:
            MethodController(call, result).find()
        }
        
        Log.type.debug("Ended method call (\(call.method))")
    }
}
