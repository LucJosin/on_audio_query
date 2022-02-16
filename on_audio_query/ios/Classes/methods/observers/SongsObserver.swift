class SongsObserver : NSObject, FlutterStreamHandler {
    
    private var obs: ObserverController?
    private var sink: FlutterEventSink?
    
    private var oldMedia: [[String: Any?]] = Array()
    
    private var pQuery: SongsQuery?
    private var pIsRunning: Bool = false
    
    var isRunning: Bool {
        get { pIsRunning }
    }
    
    var query: SongsQuery {
        get { pQuery! }
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        //
        sink = events
        
        //
        pQuery = SongsQuery(
            call: nil,
            result: nil,
            sink: self.sink,
            args: arguments as? [String: Any]
        )
        
        //
        obs = ObserverController(songsObserver: self)
        obs!.start()
        pIsRunning = true
        
        //
        pQuery?.querySongs()
        
        //
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        //
        pIsRunning = false
        
        //
        sink = nil
        pQuery = nil
        
        if obs != nil && obs!.isRunning {
            obs!.stop()
        }
        
        return nil
    }
}
