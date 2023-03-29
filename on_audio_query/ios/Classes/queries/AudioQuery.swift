import Flutter
import MediaPlayer

class AudioQuery {
    var args: [String: Any]
    var result: FlutterResult
    
    init() {
        self.args = try! PluginProvider.call().arguments as! [String: Any]
        self.result = try! PluginProvider.result()
    }
    
    func querySongs() {
        let sortType = args["sortType"] as? Int ?? 0
        
        let cursor = MPMediaQuery.songs()
        
        // Using native sort from [IOS] you can only use the [Title], [Album] and
        // [Artist]. The others will be sorted "manually" using [formatSongList] before
        // send to Dart.
        cursor.groupingType = checkSongSortType(sortType: sortType)
        
        // Filter to avoid audios/songs from cloud library.
        let cloudFilter = MPMediaPropertyPredicate(
            value: false,
            forProperty: MPMediaItemPropertyIsCloudItem
        )
        cursor.addFilterPredicate(cloudFilter)
        
        Log.type.debug("Query config: ")
        Log.type.debug("\tsortType: \(sortType)")

        // Query everything in background for a better performance.
        loadSongs(cursor: cursor)
    }
    
    private func loadSongs(cursor: MPMediaQuery!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfSongs: [[String: Any?]] = Array()
            
            // For each item(song) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>], all keys are based on [Android]
            // platforms.
            for song in cursor.items! {
                // Ignore cloud items.
                if !song.isCloudItem, song.assetURL != nil {
                    let songData = loadSongItem(song: song)
                    listOfSongs.append(songData)
                }
            }
            
            DispatchQueue.main.async {
                // Custom sort/order.
                let finalList = formatSongList(args: self.args, allSongs: listOfSongs)
                self.result(finalList)
            }
        }
    }
}
