import Flutter
import MediaPlayer

class ArtworkQuery {
    var args: [String: Any]
    var result: FlutterResult
    
    init(call: FlutterMethodCall, result: @escaping FlutterResult) {
        // To make life easy, add all arguments inside a map.
        self.args = call.arguments as! [String: Any]
        self.result = result
    }
    
    // [IOS] has a different artwork system and you can "query" using normal "querySongs, .."
    // [Android] can't "query" artwork at the same time as "querySongs", so we need to "query"
    // using a different method(queryArtwork).
    //
    // To match both [IOS] and [Android], [queryArtwork] is the only way to get artwork.
    //
    // Not the best solution but, at least here we can select differents formats and size.
    func queryArtwork() {
        // None of this arguments can be null.
        // The id of the [Song] or [Album].
        let id = args["id"] as! Int
        
        // The size of the image.
        let size = args["size"] as! Int
        
        // The size of the image.
        var quality = args["quality"] as! Int
        if (quality > 100) {
            quality = 50
        }
        
        // The format [JPEG] or [PNG].
        let format = args["format"] as! Int
        
        // The uri [0]: Song and [1]: Album.
        let uri = args["type"] as! Int
        
        // (To match android side, let's call "cursor").
        var cursor: MPMediaQuery?
        var filter: MPMediaPropertyPredicate?
        
        // If [uri] is 0: artwork from [Song]
        // If [uri] is 1: artwork from [Album]
        // If [uri] is 2: artwork from [Playlist]
        // If [uri] is 3: artwork from [Artist]
        switch uri {
        case 0:
            filter = MPMediaPropertyPredicate.init(value: id, forProperty: MPMediaItemPropertyPersistentID)
            cursor = MPMediaQuery.songs()
        case 1:
            filter = MPMediaPropertyPredicate.init(value: id, forProperty: MPMediaItemPropertyAlbumPersistentID)
            cursor = MPMediaQuery.albums()
        case 2:
            filter = MPMediaPropertyPredicate.init(value: id, forProperty: MPMediaPlaylistPropertyPersistentID)
            cursor = MPMediaQuery.playlists()
        case 3:
            filter = MPMediaPropertyPredicate.init(value: id, forProperty: MPMediaItemPropertyArtistPersistentID)
            cursor = MPMediaQuery.artists()
        case 4:
            filter = MPMediaPropertyPredicate.init(value: id, forProperty: MPMediaItemPropertyGenrePersistentID)
            cursor = MPMediaQuery.genres()
        default:
            filter = nil
            cursor = nil
        }
        
        // Request permission status from the 'main' method.
        let hasPermission = SwiftOnAudioQueryPlugin().checkPermission()
        
        // We cannot 'query' without permission so, throw a PlatformException.
        if !hasPermission {
            // Method from 'MethodChannel' (method)
            self.result(
                FlutterError.init(
                    code: "403",
                    message: "The app doesn't have permission to read files.",
                    details: "Call the [permissionsRequest] method or install a external plugin to handle the app permission."
                )
            )
            
            // 'Exit' the function
            return
        }
        
        //
        if cursor != nil && filter != nil {
            cursor?.addFilterPredicate(filter!)
            
            // This filter will avoid audios/songs outside phone library(cloud).
            let cloudFilter = MPMediaPropertyPredicate.init(
                value: false,
                forProperty: MPMediaItemPropertyIsCloudItem
            )
            cursor?.addFilterPredicate(cloudFilter)
            
            // Query everything in background for a better performance.
            loadArtwork(cursor: cursor, size: size, format: format, uri: uri, quality: quality)
        } else {
            // Return to Flutter
            result(nil)
        }
    }
    
    private func loadArtwork(cursor: MPMediaQuery!, size: Int, format: Int, uri: Int, quality: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            var artwork: Data?
            var item: MPMediaItem?
            let fixedQuality = CGFloat(Double(quality) / 100.0)
            
            // If [uri] is 0: artwork is from [Song]
            // If [uri] is 1, 2 or 3: artwork is from [Album], [Playlist] or [Artist]
            if uri == 0 {
                // Since all id are unique, we can safely call the first item.
                item = cursor!.items?.first
            } else {
                // Since all id are unique, we can safely call the first item.
                item = cursor!.collections?.first?.items.first
            }
            
            // If [format] is 0: will be [JPEG]
            // If [format] is 1: will be [PNG]
            if format == 0 {
                artwork = item?.artwork?.image(at: CGSize(width: size, height: size))?.jpegData(compressionQuality: fixedQuality)
            } else {
                // [PNG] format will return a high image quality.
                artwork = item?.artwork?.image(at: CGSize(width: size, height: size))?.pngData()
            }
            
            // After finish the "query", go back to the "main" thread(You can only call flutter
            // inside the main thread).
            DispatchQueue.main.async {
                // We don't need a "empty" image so, return null to avoid problems.
                if artwork != nil && artwork!.isEmpty {
                    artwork = nil
                }
                self.result(
                    [
                        "artwork": artwork,
                        "path": nil,
                        "type": format == 0 ? "JPEG" : "PNG",
                    ]
                )
            }
        }
    }
}
