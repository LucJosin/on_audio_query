import Flutter
import MediaPlayer

class ArtistsQuery {
    var args: [String: Any]
    var result: FlutterResult?
    var sink: FlutterEventSink?
    
    init(
        call: FlutterMethodCall? = nil,
        result: FlutterResult? = nil,
        sink: FlutterEventSink? = nil,
        args: [String: Any]? = nil) {
        // Add all arguments inside a map.
        self.args = sink != nil ? args! : call!.arguments as! [String: Any]
        self.sink = sink
        self.result = result
    }
    
    func queryArtists() {
        // Choose the type(To match android side, let's call "cursor").
        let cursor = MPMediaQuery.artists()
        
        // We don't need to define a sortType here. [IOS] only support
        // the [Artist]. The others will be sorted "manually" using
        // [formatSongList] before send to Dart.
        
        // This filter will avoid audios/songs outside phone library(cloud).
        let cloudFilter = MPMediaPropertyPredicate.init(
            value: false,
            forProperty: MPMediaItemPropertyIsCloudItem
        )
        cursor.addFilterPredicate(cloudFilter)
        
        // We cannot "query" without permission so, just return a empty list.
        let hasPermission = SwiftOnAudioQueryPlugin().checkPermission()
        if hasPermission {
            // Query everything in background for a better performance.
            loadArtists(cursor: cursor.collections)
        } else {
            // There's no permission so, return empty to avoid crashes.
            if sink != nil {
                sink!([])
            } else {
                result!([])
            }
        }
    }
    
    private func loadArtists(cursor: [MPMediaItemCollection]!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfArtists: [[String: Any?]] = Array()
            
            // For each item(artist) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>], all keys are based on [Android]
            // platforms so, if you change some key, will have to change the [Android] too.
            for artist in cursor {
                // If the first song file don't has a assetURL, is a Cloud item.
                if !artist.items[0].isCloudItem && artist.items[0].assetURL != nil {
                    let artistData = loadArtistItem(artist: artist)
                    listOfArtists.append(artistData)
                }
            }
            
            // After finish the "query", go back to the "main" thread(You can only call flutter
            // inside the main thread).
            DispatchQueue.main.async {
                // Here we'll check the "custom" sort and define a order to the list.
                let finalList = formatArtistList(args: self.args, allArtists: listOfArtists)
                if self.sink != nil {
                    self.sink!(finalList)
                } else {
                    self.result!(finalList)
                }
            }
        }
    }
}
