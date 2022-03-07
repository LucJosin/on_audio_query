import Flutter
import MediaPlayer

class GenresQuery {
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
    
    func queryGenres() {
        // Choose the type(To match android side, let's call "cursor").
        let cursor = MPMediaQuery.genres()
        
        // We don't need to define a sortType here. [IOS] only support
        // the [Artist]. The others will be sorted "manually" using
        // [formatSongList] before send to Dart.
        
        // This filter will avoid audios/songs outside phone library(cloud).
        let cloudFilter = MPMediaPropertyPredicate.init(
            value: false,
            forProperty: MPMediaItemPropertyIsCloudItem
        )
        cursor.addFilterPredicate(cloudFilter)
        
        // Request permission status from the 'main' method.
        let hasPermission = SwiftOnAudioQueryPlugin().checkPermission()
        
        // We cannot 'query' without permission so, throw a PlatformException.
        // Only one 'channel' will be 'functional'. If is null, ignore, if not, send the error.
        if !hasPermission {
            // Method from 'EventChannel' (observer)
            self.sink?(
                FlutterError.init(
                    code: "403",
                    message: "The app doesn't have permission to read files.",
                    details: "Call the [permissionsRequest] method or install a external plugin to handle the app permission."
                )
            )
            
            // Method from 'MethodChannel' (method)
            self.result?(
                FlutterError.init(
                    code: "403",
                    message: "The app doesn't have permission to read files.",
                    details: "Call the [permissionsRequest] method or install a external plugin to handle the app permission."
                )
            )
            
            // 'Exit' the function
            return
        }
        
        // Query everything in background for a better performance.
        loadGenres(cursor: cursor.collections)
    }
    
    private func loadGenres(cursor: [MPMediaItemCollection]!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfGenres: [[String: Any?]] = Array()
            
            // For each item(genre) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>], all keys are based on [Android]
            // platforms so, if you change some key, will have to change the [Android] too.
            for genre in cursor {
                if !genre.items[0].isCloudItem && genre.items[0].assetURL != nil {
                    var genreData = loadGenreItem(genre: genre)
                    
                    // Count and add the number of songs for every genre.
                    let tmpMediaCount = getMediaCount(type: 0, id: genreData["_id"] as! UInt64)
                    genreData["num_of_songs"] = tmpMediaCount
                    
                    listOfGenres.append(genreData)
                }
            }
            
            // After finish the "query", go back to the "main" thread(You can only call flutter
            // inside the main thread).
            DispatchQueue.main.async {
                // Here we'll check the "custom" sort and define a order to the list.
                let finalList = formatGenreList(args: self.args, allGenres: listOfGenres)
                
                // After loading the information, send the 'result'.
                self.sink?(finalList)
                self.result?(finalList)
            }
        }
    }
}
