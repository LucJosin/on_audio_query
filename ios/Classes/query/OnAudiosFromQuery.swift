import Flutter
import MediaPlayer

class OnAudiosFromQuery {
    var args: [String: Any]
    var result: FlutterResult
    var type: Int = -1
    
    init(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.args = call.arguments as! [String: Any]
        self.result = result
    }
    
    func queryAudiosFrom() {
        self.type = args["type"] as! Int
        let wh3re = args["where"] as Any
        var cursor: MPMediaQuery? = checkAudiosFrom(type: type, where: wh3re)
        if self.type != 6 && cursor != nil {
            loadQueryAudiosFrom(cursor: cursor!)
        } else {
            cursor = MPMediaQuery.playlists()
            loadSongsFromPlaylist(cursor: cursor!.collections)
        }
    }
    
    internal func loadQueryAudiosFrom(cursor: MPMediaQuery!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfSongs: [[String: Any?]] = Array()
            
            for song in cursor.items! {
                let songData = loadSongItem(song: song)
                listOfSongs.append(songData)
            }
            
            DispatchQueue.main.async {
                self.result(listOfSongs)
            }
        }
    }
    
    //Add a better code
    internal func loadSongsFromPlaylist(cursor: [MPMediaItemCollection]!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfSongs: [[String: Any?]] = Array()
            
            for playlist in cursor {
                let iPlaylist = playlist as! MPMediaPlaylist
                let iWhere = self.args["where"] as Any
                //Using this check we can define if [where] is the [Playlist] name or id
                if iWhere is String {
                    //Check if playlist name is equal to defined name
                    if iPlaylist.name == iWhere as? String {
                        //For each song, format and add to the list
                        for song in playlist.items {
                            let songData = loadSongItem(song: song)
                            listOfSongs.append(songData)
                        }
                    }
                } else {
                    //Check if playlist id is equal to defined id
                    if iPlaylist.persistentID == iWhere as! Int {
                        //For each song, format and add to the list
                        for song in playlist.items {
                            let songData = loadSongItem(song: song)
                            listOfSongs.append(songData)
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.result(listOfSongs)
            }
        }
    }
}
