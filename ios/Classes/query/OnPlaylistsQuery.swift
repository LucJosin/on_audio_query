import Flutter
import MediaPlayer

class OnPlaylistsQuery {
    var args: [String: Any]
    var result: FlutterResult
    
    init(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.args = call.arguments as! [String: Any]
        self.result = result
    }
    
    func queryPlaylists() {
        let cursor = MPMediaQuery.playlists()
        loadPlaylists(cursor: cursor.collections)
    }
    
    internal func loadPlaylists(cursor: [MPMediaItemCollection]!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfPlaylists: [[String: Any?]] = Array()
            
            for playlist in cursor {
                let playlistData = loadPlaylistItem(playlist: playlist)
                listOfPlaylists.append(playlistData)
            }
            
            DispatchQueue.main.async {
                self.result(listOfPlaylists)
            }
        }
    }
}
