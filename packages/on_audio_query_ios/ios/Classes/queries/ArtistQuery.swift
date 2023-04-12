import Flutter
import MediaPlayer

class ArtistQuery {
    var args: [String: Any]
    var result: FlutterResult
    
    init() {
        self.args = try! PluginProvider.call().arguments as! [String: Any]
        self.result = try! PluginProvider.result()
    }
    
    func queryArtists() {
        let cursor = MPMediaQuery.artists()
        
        // We don't need to define a sortType here. [IOS] only support
        // the [Artist]. The others will be sorted "manually" using
        // [formatSongList] before send to Dart.
        
        // Filter to avoid audios/songs from cloud library.
        let cloudFilter = MPMediaPropertyPredicate(
            value: false,
            forProperty: MPMediaItemPropertyIsCloudItem
        )
        cursor.addFilterPredicate(cloudFilter)

        loadArtists(cursor: cursor.collections)
    }
    
    private func loadArtists(cursor: [MPMediaItemCollection]!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfArtists: [[String: Any?]] = Array()
            
            // For each item(artist) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>], all keys are based on [Android]
            // platforms.
            for artist in cursor {
                if !artist.items[0].isCloudItem, artist.items[0].assetURL != nil {
                    let artistData = loadArtistItem(artist: artist)
                    listOfArtists.append(artistData)
                }
            }
            
            DispatchQueue.main.async {
                // Custom sort/order.
                let finalList = formatArtistList(args: self.args, allArtists: listOfArtists)
                self.result(finalList)
            }
        }
    }
}
