import Flutter
import MediaPlayer

class OnPlaylistsController {
    var args: [String: Any]
    var result: FlutterResult
    
    init(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.args = call.arguments as! [String: Any]
        self.result = result
    }
    
    func createPlaylist() {
        let playlistName = args["playlistName"] as! String
        let playlistAuthor = args["playlistAuthor"] as? String
        let playlistDesc = args["playlistDesc"] as? String
        let playlistMetadata = MPMediaPlaylistCreationMetadata.init(name: playlistName)
        playlistMetadata.authorDisplayName = playlistAuthor
        playlistMetadata.descriptionText = playlistDesc ?? ""
        MPMediaLibrary().getPlaylist(with: UUID.init(), creationMetadata: playlistMetadata, completionHandler: { playlist, error in
            //A little second to create the playlist and Flutter UI update
            sleep(1)
            if playlist != nil {
                self.result(true)
            } else {
                print(error ?? "Something wrong happend")
                self.result(false)
            }
        }
        )
    }
}
