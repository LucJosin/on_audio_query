import Flutter
import MediaPlayer

class AlbumQuery {
    var args: [String: Any]
    var result: FlutterResult
    
    init() {
        self.args = try! PluginProvider.call().arguments as! [String: Any]
        self.result = try! PluginProvider.result()
    }
    
    func queryAlbums() {
        let sortType = args["sortType"] as? Int ?? 0
        
        let cursor = MPMediaQuery.albums()
        
        // Using native sort from [IOS] you can only use the [Album] and [Artist].
        // The others will be sorted "manually" using [formatAlbumList] before
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
        loadAlbums(cursor: cursor.collections)
    }
    
    private func loadAlbums(cursor: [MPMediaItemCollection]!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfAlbums: [[String: Any?]] = Array()
            
            // For each item(album) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>], all keys are based on [Android]
            // platforms.
            for album in cursor {
                if !album.items[0].isCloudItem, album.items[0].assetURL != nil {
                    let albumData = loadAlbumItem(album: album)
                    listOfAlbums.append(albumData)
                }
            }
            
            DispatchQueue.main.async {
                // Custom sort/order.
                let finalList = formatAlbumList(args: self.args, allAlbums: listOfAlbums)
                self.result(finalList)
            }
        }
    }
}
