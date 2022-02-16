import MediaPlayer

class ObserverController : NSObject {
    
    private var songsObserver: SongsObserver? = nil
    
    init(songsObserver: SongsObserver?) {
        self.songsObserver = songsObserver
    }
    
    private let library = MPMediaLibrary.default()
    private let notification = NotificationCenter.default
    
    private var pIsRunning: Bool = false
    
    var isRunning: Bool {
        get { pIsRunning }
    }
    
    func start() {
        print(pIsRunning)
        if !isRunning {
            //
            library.beginGeneratingLibraryChangeNotifications()
            
            //
            notification.addObserver(
                self,
                selector: #selector(notifyObservers(notification:)),
                name: .MPMediaLibraryDidChange,
                object: nil
            )
            
            pIsRunning = true
        }
    }
    
    @objc private func notifyObservers(notification: NSNotification) {
        print(songsObserver == nil)
        print(songsObserver?.isRunning ?? "nil")
        if songsObserver != nil && songsObserver!.isRunning {
            songsObserver!.query.querySongs()
        }
    }
    
    func stop() {
        print("Stop")
        if songsObserver == nil {
            library.endGeneratingLibraryChangeNotifications()
            
            notification.removeObserver(
                self,
                name: .MPMediaLibraryDidChange,
                object: nil
            )
            
            pIsRunning = false
        }
    }
}
