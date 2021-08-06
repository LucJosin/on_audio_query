import Flutter
import MediaPlayer

class OnAudioQuery {
    var args: [String: Any]
    var result: FlutterResult
    
    init(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.args = call.arguments as! [String: Any]
        self.result = result
    }
    
    func querySongs() {
        let sortType = args["sortType"] as! Int
        
        let cursor = MPMediaQuery.songs()
        cursor.groupingType = checkSongSortType(sortType: sortType)
        loadSongs(cursor: cursor)
    }
    
    internal func loadSongs(cursor: MPMediaQuery!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfSongs: [[String: Any?]] = Array()
            
            for song in cursor.items! {
                let songData = loadSongItem(song: song)
                listOfSongs.append(songData)
            }
            
            DispatchQueue.main.async {
                let finalList = formatSongList(args: self.args, allSongs: listOfSongs)
                self.result(finalList)
            }
        }
    }
}
