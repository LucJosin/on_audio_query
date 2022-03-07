import Flutter
import MediaPlayer

class PlaylistsQuery {
    var args: [String: Any]
    var result: FlutterResult?
    var sink: FlutterEventSink?
    
    init(
        call: FlutterMethodCall? = nil,
        result: FlutterResult? = nil,
        sink: FlutterEventSink? = nil,
        args: [String: Any]? = nil) {
        // Add all arguments inside a map.
        self.args = sink != nil ? args! : call!.arguments as! [String: Any]
        self.sink = sink
        self.result = result
    }
    
    func queryPlaylists() {
        // Choose the type(To match android side, let's call "cursor").
        let cursor = MPMediaQuery.playlists()
        
        // TODO: Add sort type to [queryPlaylists].
        
        // This filter will avoid audios/songs outside phone library(cloud).
        let cloudFilter = MPMediaPropertyPredicate.init(
            value: false,
            forProperty: MPMediaItemPropertyIsCloudItem
        )
        cursor.addFilterPredicate(cloudFilter)
        
        // Request permission status from the 'main' method.
        let hasPermission = SwiftOnAudioQueryPlugin().checkPermission()
        
        // We cannot 'query' without permission so, throw a PlatformException.
        // Only one 'channel' will be 'functional'. If is null, ignore, if not, send the error.
        if !hasPermission {
            // Method from 'EventChannel' (observer)
            self.sink?(
                FlutterError.init(
                    code: "403",
                    message: "The app doesn't have permission to read files.",
                    details: "Call the [permissionsRequest] method or install a external plugin to handle the app permission."
                )
            )
            
            // Method from 'MethodChannel' (method)
            self.result?(
                FlutterError.init(
                    code: "403",
                    message: "The app doesn't have permission to read files.",
                    details: "Call the [permissionsRequest] method or install a external plugin to handle the app permission."
                )
            )
            
            // 'Exit' the function
            return
        }
        
        // Query everything in background for a better performance.
        loadPlaylists(cursor: cursor.collections)
    }
    
    private func loadPlaylists(cursor: [MPMediaItemCollection]!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfPlaylists: [[String: Any?]] = Array()
            
            // For each item(playlist) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>], all keys are based on [Android]
            // platforms so, if you change some key, will have to change the [Android] too.
            for playlist in cursor {
                var playlistData = loadPlaylistItem(playlist: playlist)
                
                // If the first song file doesn't has a assetURL, is probably a Cloud item.
                if !playlist.items.isEmpty && !playlist.items[0].isCloudItem && playlist.items[0].assetURL != nil {
                    // Count and add the number of songs for every genre.
                    let tmpMediaCount = getMediaCount(type: 1, id: playlistData["_id"] as! UInt64)
                    playlistData["num_of_songs"] = tmpMediaCount
                } else {
                    playlistData["num_of_songs"] = 0
                }
                
                listOfPlaylists.append(playlistData)
            }
            
            // After finish the "query", go back to the "main" thread(You can only call flutter
            // inside the main thread).
            DispatchQueue.main.async {
                // TODO: Add sort type to [queryPlaylists].
                
                // After loading the information, send the 'result'.
                self.sink?(listOfPlaylists)
                self.result?(listOfPlaylists)
            }
        }
    }
}
