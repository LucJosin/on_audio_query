import Flutter
import MediaPlayer

class GenreQuery {
    var args: [String: Any]
    var result: FlutterResult
    
    init(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.args = call.arguments as! [String: Any]
        self.result = result
    }
    
    func queryGenres() {
        let cursor = MPMediaQuery.genres()
        
        // We don't need to define a sortType here. [IOS] only support
        // the [Artist]. The others will be sorted "manually" using
        // [formatSongList] before send to Dart.
        
        // Filter to avoid audios/songs from cloud library.
        let cloudFilter = MPMediaPropertyPredicate(
            value: false,
            forProperty: MPMediaItemPropertyIsCloudItem
        )
        cursor.addFilterPredicate(cloudFilter)
        
        // We cannot "query" without permission so, just return a empty list.
        let hasPermission = PermissionController.checkPermission()
        if hasPermission {
            // Query everything in background for a better performance.
            loadGenres(cursor: cursor.collections)
        } else {
            // There's no permission so, return empty to avoid crashes.
            result([])
        }
    }
    
    private func loadGenres(cursor: [MPMediaItemCollection]!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfGenres: [[String: Any?]] = Array()
            
            // For each item(genre) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>], all keys are based on [Android]
            // platforms.
            for genre in cursor {
                if !genre.items[0].isCloudItem, genre.items[0].assetURL != nil {
                    var genreData = loadGenreItem(genre: genre)
                    
                    // Count and add the number of songs for every genre.
                    let tmpMediaCount = getMediaCount(type: 0, id: genreData["_id"] as! UInt64)
                    genreData["num_of_songs"] = tmpMediaCount
                    
                    listOfGenres.append(genreData)
                }
            }
            
            DispatchQueue.main.async {
                // Custom sort/order.
                let finalList = formatGenreList(args: self.args, allGenres: listOfGenres)
                self.result(finalList)
            }
        }
    }
}
