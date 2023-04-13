/**
 * A singleton used to define all variables/methods that will be used on all plugin.
 *
 * The singleton will provider the ability to 'request' required variables/methods on any moment.
 *
 * All variables/methods should be defined after dart request (call/result).
 */
enum PluginProvider {
    private static let ERROR_MESSAGE = "Tried to get one of the methods but the 'PluginProvider' has not been initialized"
    
    private static var _call: FlutterMethodCall?
    
    private static var _result: FlutterResult?
    
    /**
     * Define if 'warn' level will show more detailed logging.
     *
     * Will be used when a query produce some error.
     */
    static var showDetailedLog: Bool = false
    
    /**
     * Used to define the current dart request.
     *
     * Should be defined/redefined on every [handle] request.
     */
    static func set(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        PluginProvider._call = call
        PluginProvider._result = result
    }
    
    /**
     * The current plugin 'call'. Will be replace with newest dart request.
     *
     * - throws UninitializedPluginProviderException
     * - returns [MethodCall]
     */
    static func call() throws -> FlutterMethodCall {
        guard _call != nil else {
            throw PluginProviderException.unitialized(ERROR_MESSAGE)
        }
        
        return _call!
    }
    
    /**
     * The current plugin 'result'. Will be replace with newest dart request.
     *
     * - throws UninitializedPluginProviderException
     * - returns [MethodChannel.Result]
     */
    static func result() throws -> FlutterResult {
        guard _result != nil else {
            throw PluginProviderException.unitialized(ERROR_MESSAGE)
        }
        
        return _result!
    }
    
    enum PluginProviderException: Error {
        case unitialized(String)
    }
}
