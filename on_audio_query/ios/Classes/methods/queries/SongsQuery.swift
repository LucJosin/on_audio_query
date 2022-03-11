import Flutter
import MediaPlayer

class SongsQuery {
    // Main parameters
    private var args: [String: Any]
    private var result: FlutterResult?
    private var sink: FlutterEventSink?
    
    // Song projection (to filter).
    private let songProjection: [String?] = [
        "_id",
        "_data",
        "_display_name",
        nil,
        "album",
        nil,
        "album_id",
        "artist",
        "artist_id",
        nil,
        "composer",
        nil,
        nil,
        nil,
        "title",
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
    ]
    
    init(
        // Call from 'MethodChannel' (method).
        call: FlutterMethodCall? = nil,
        result: FlutterResult? = nil,
        // Call from 'EventChannel' (observer).
        sink: FlutterEventSink? = nil,
        args: [String: Any]? = nil
    ) {
        // Get all arguments inside the map.
        self.args = sink != nil ? args! : (call!.arguments as! [String: Any])
        self.sink = sink
        self.result = result
    }
    
    func querySongs() {
        // The sortType. If 'nil', will be set as [Title].
        let sortType = args["sortType"] as? Int ?? 0
        
        // Choose the type(To match android side, let's call "cursor").
        let cursor = MPMediaQuery.songs()
        
        // Make sure that only audios with 'music' type will be 'queried'.
        cursor.addFilterPredicate(MPMediaPropertyPredicate.init(
            value: MPMediaType.music.rawValue,
            forProperty: MPMediaItemPropertyMediaType,
            comparisonType: .equalTo
        ))
        
        // This filter will avoid audios/songs outside phone library(cloud).
        //
        // Sometimes this filter won't work.
        cursor.addFilterPredicate(MPMediaPropertyPredicate.init(
            value: false,
            forProperty: MPMediaItemPropertyIsCloudItem,
            comparisonType: .equalTo
        ))
        
        // Using native sort from [IOS] you can only use the [Title], [Album] and
        // [Artist]. The others will be sorted 'manually' using [formatSongList] before
        // sending to Dart.
        cursor.groupingType = checkSongSortType(sortType: sortType)
        
        // Request permission status from the 'main' method.
        let hasPermission = SwiftOnAudioQueryPlugin().checkPermission()
        
        // We cannot 'query' without permission so, throw a PlatformException.
        // Only one 'channel' will be 'functional'. If is null, ignore, if not, send the error.
        if !hasPermission {
            // Call from 'EventChannel' (observer)
            self.sink?(
                FlutterError.init(
                    code: "403",
                    message: "The app doesn't have permission to read files.",
                    details: "Call the [permissionsRequest] method or install a external plugin to handle the app permission."
                )
            )
            
            // Call from 'MethodChannel' (method)
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
        
        // If [items] is null. Call early return with empty list.
        if cursor.items == nil {
            // Empty list.
            self.sink?([])
            self.result?([])
            
            // 'Exit' the function.
            return
        }
        
        // Query everything in background for a better performance.
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfSongs: [[String: Any?]] = Array()
            
            // For each item(song) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>], all keys are based on [Android]
            // platforms so, if you change some key, will have to change the [Android] too.
            for song in cursor.items! {
                // If the song file don't has a assetURL, is a Cloud item.
                if !song.isCloudItem && song.assetURL != nil {
                    let songData = self.loadSongItem(song: song)
                    listOfSongs.append(songData)
                }
            }
            
            // Define the [toQuery] and [toRemove] filter.
            let toQuery = self.args["toQuery"] as! [Int: [String]]
            let toRemove = self.args["toRemove"] as! [Int: [String]]
            
            // 'Build' the filter.
            listOfSongs = listOfSongs.mediaFilter(
                mediaProjection: self.songProjection,
                toQuery: toQuery,
                toRemove: toRemove
            )
            
            // After finish the "query", go back to the "main" thread(You can only call flutter
            // inside the main thread).
            DispatchQueue.main.async {
                // Here we'll check the "custom" sort and define a order to the list.
                let finalList = self.formatSongList(allSongs: listOfSongs)
                
                // After loading the information, send the 'result'.
                self.sink?(finalList)
                self.result?(finalList)
            }
        }
    }
    
    private func loadSongItem(song: MPMediaItem) -> [String: Any?] {
        let fileExt = song.assetURL?.pathExtension ?? ""
        let sizeInBytes = song.value(forProperty: "fileSize") as? Int
        return [
            "_id": song.persistentID,
            "_data": song.assetURL?.absoluteString,
            "_uri": song.assetURL?.absoluteString,
            "_display_name": "\(song.artist ?? "") - \(song.title ?? "").\(fileExt)",
            "_display_name_wo_ext": "\(song.artist ?? "") - \(song.title ?? "")",
            "_size": sizeInBytes,
            "audio_id": nil,
            "album": song.albumTitle,
            "album_id": song.albumPersistentID,
            "artist": song.artist,
            "artist_id": song.artistPersistentID,
            "genre": song.genre,
            "genre_id": song.genrePersistentID,
            "bookmark": Int(song.bookmarkTime),
            "composer": song.composer,
            "date_added": Int(song.dateAdded.timeIntervalSince1970),
            "date_modified": 0,
            "duration": Int(song.playbackDuration * 1000),
            "title": song.title,
            "track": song.albumTrackNumber,
            "file_extension": fileExt,
        ]
    }
    
    private func formatSongList(allSongs: [[String: Any?]]) -> [[String: Any?]] {
        // Define a copy of all songs.
        var allSongsCopy = allSongs
        
        // Define all 'basic' filters.
        let order = args["orderType"] as? Int
        let sortType = args["sortType"] as? Int
        let ignoreCase = args["ignoreCase"] as! Bool
        
        // Sort the list 'manually'.
        switch sortType {
        case 3:
            allSongsCopy.sort { (val1, val2) in
                (val1["duration"] as! Double) > (val2["duration"] as! Double)
            }
        case 4:
            allSongsCopy.sort { (val1, val2) in
                (val1["date_added"] as! Int) > (val2["date_added"] as! Int)
            }
        case 5:
            allSongsCopy.sort { (val1, val2) in
                (val1["_size"] as! Int) > (val2["_size"] as! Int)
            }
        case 6:
            allSongsCopy.sort { (val1, val2) in
                ((val1["_display_name"] as! String).isCase(ignoreCase: ignoreCase)) > ((val2["_display_name"] as! String).isCase(ignoreCase: ignoreCase))
            }
        case 7:
            allSongsCopy.sort { (val1, val2) in
                (val1["track"] as! Int) > (val2["track"] as! Int)
            }
        default:
            break
        }
        
        // The order value is [1], reverse the list.
        return order == 1 ? allSongsCopy.reversed() : allSongsCopy
    }
}
