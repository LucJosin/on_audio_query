import Flutter
import MediaPlayer

class PlaylistController {
    var args: [String: Any]
    var result: FlutterResult
    
    init() {
        self.args = try! PluginProvider.call().arguments as! [String: Any]
        self.result = try! PluginProvider.result()
    }
    
    func createPlaylist() {
        let playlistName = args["playlistName"] as! String
        let playlistAuthor = args["playlistAuthor"] as? String
        let playlistDesc = args["playlistDesc"] as? String
        
        Log.type.debug("Playlist info: ")
        Log.type.debug("\tname: \(playlistName)")
        Log.type.debug("\tauthor: \(String(describing: playlistAuthor))")
        Log.type.debug("\tdescription: \(String(describing: playlistDesc))")
        
        let playlistMetadata = MPMediaPlaylistCreationMetadata(name: playlistName)
        playlistMetadata.authorDisplayName = playlistAuthor
        playlistMetadata.descriptionText = playlistDesc ?? ""
        
        MPMediaLibrary().getPlaylist(with: UUID(), creationMetadata: playlistMetadata, completionHandler: { playlist, _ in
            sleep(1)
            
            let playlistHasBeenCreated = playlist != nil
            Log.type.debug("Playlist has been created: \(playlistHasBeenCreated)")
            
            self.result(playlistHasBeenCreated)
        })
    }
    
    func addToPlaylist() {
        let playlistId = args["playlistId"] as! Int
        let audioId = args["audioId"] as! Int
        
        Log.type.debug("Playlist info: ")
        Log.type.debug("\tid: \(playlistId)")
        Log.type.debug("\taudioId: \(audioId)")
        
        // TODO: Use another method to get UUID from playlist
        //
        // Link: https://github.com/HumApp/MusicKit/blob/master/AppleMusicSample/Controllers/MediaLibraryManager.swift
        let playlist: MPMediaPlaylist? = loadPlaylist(id: playlistId)
        
        // [addItem] won't work in the main thread.
        DispatchQueue.global(qos: .userInitiated).async {
            var hasBeenAdded = false
            
            if playlist != nil {
                Log.type.debug("Found playlist! Name: \(playlist?.name ?? "Unknown")")
                
                playlist!.addItem(withProductID: String(audioId), completionHandler: { error in
                    let hasError = error != nil
                    
                    if hasError {
                        Log.type.error(error.debugDescription)
                    }
        
                    hasBeenAdded = !hasError
                })
            }
            
            DispatchQueue.main.async {
                Log.type.debug("Item (\(audioId)) has been added: \(hasBeenAdded)")
                self.result(hasBeenAdded)
            }
        }
    }
    
    private func loadPlaylist(id: Int) -> MPMediaPlaylist? {
        let cursor = MPMediaQuery.playlists()
        
        // Create a filter using the playlist id.
        let playlistFilter = MPMediaPropertyPredicate(value: id, forProperty: MPMediaPlaylistPropertyPersistentID)
        
        // Remove any cloud playlist.
        let noCloudItemFilter = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        
        cursor.addFilterPredicate(playlistFilter)
        cursor.addFilterPredicate(noCloudItemFilter)

        return cursor.collections?.first as? MPMediaPlaylist
    }
}
