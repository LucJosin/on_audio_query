import Flutter
import MediaPlayer

class PlaylistQuery {
    var args: [String: Any]
    var result: FlutterResult
    
    init() {
        self.args = try! PluginProvider.call().arguments as! [String: Any]
        self.result = try! PluginProvider.result()
    }
    
    func queryPlaylists() {
        let cursor = MPMediaQuery.playlists()
        
        // TODO: Add sort type to [queryPlaylists].
        
        // Filter to avoid audios/songs from cloud library.
        let cloudFilter = MPMediaPropertyPredicate(
            value: false,
            forProperty: MPMediaItemPropertyIsCloudItem
        )
        cursor.addFilterPredicate(cloudFilter)
        
        // Query everything in background for a better performance.
        loadPlaylists(cursor: cursor.collections)
    }
    
    private func loadPlaylists(cursor: [MPMediaItemCollection]!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfPlaylists: [[String: Any?]] = Array()
            
            // For each item(playlist) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>], all keys are based on [Android]
            // platforms.
            for playlist in cursor {
                // Ignore cloud items.
                if !playlist.items[0].isCloudItem, playlist.items[0].assetURL != nil {
                    var playlistData = loadPlaylistItem(playlist: playlist)
                    
                    // Count and add the number of songs for every genre.
                    let tmpMediaCount = getMediaCount(type: 1, id: playlistData["_id"] as! UInt64)
                    playlistData["num_of_songs"] = tmpMediaCount
                    
                    listOfPlaylists.append(playlistData)
                }
            }
            
            DispatchQueue.main.async {
                // TODO: Add sort type to [queryPlaylists].
                self.result(listOfPlaylists)
            }
        }
    }
}
