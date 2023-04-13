import Flutter
import MediaPlayer

class ArtworkQuery {
    var args: [String: Any]
    var result: FlutterResult
    
    init() {
        self.args = try! PluginProvider.call().arguments as! [String: Any]
        self.result = try! PluginProvider.result()
    }
    
    // [IOS] has a different artwork system and you can "query" using normal "querySongs, .."
    // [Android] can't "query" artwork at the same time as "querySongs", so we need to "query"
    // using a different method(queryArtwork).
    //
    // To match both [IOS] and [Android], [queryArtwork] is the only way to get artwork.
    //
    // Not the best solution but, at least here we can select differents formats and size.
    func queryArtwork() {
        // The 'id' of the [Song] or [Album].
        let id = args["id"] as! Int
        
        // The 'size' of the image.
        let size = args["size"] as! Int
        
        // The 'size' of the image.
        var quality = args["quality"] as! Int
        if quality > 100 {
            quality = 50
        }
        
        // The format
        //  * 0 -> JPEG
        //  * 1 -> PNG
        let format = args["format"] as! Int
        
        var cursor: MPMediaQuery?
        var filter: MPMediaPropertyPredicate?
            
        let uri = args["type"] as! Int
        switch uri {
        case 0:
            filter = MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyPersistentID)
            cursor = MPMediaQuery.songs()
        case 1:
            filter = MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyAlbumPersistentID)
            cursor = MPMediaQuery.albums()
        case 2:
            filter = MPMediaPropertyPredicate(value: id, forProperty: MPMediaPlaylistPropertyPersistentID)
            cursor = MPMediaQuery.playlists()
        case 3:
            filter = MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyArtistPersistentID)
            cursor = MPMediaQuery.artists()
        case 4:
            filter = MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyGenrePersistentID)
            cursor = MPMediaQuery.genres()
        default:
            filter = nil
            cursor = nil
        }
        
        if cursor == nil || filter == nil {
            Log.type.warning("Cursor or filter has null value!")
            result(nil)
            return
        }
        
        Log.type.debug("Query config: ")
        Log.type.debug("\tid: \(id)")
        Log.type.debug("\tsize: \(size)")
        Log.type.debug("\tquality: \(quality)")
        Log.type.debug("\tformat: \(format)")
        Log.type.debug("\turi: \(uri)")
        Log.type.debug("\tfilter: \(String(describing: filter))")

        cursor!.addFilterPredicate(filter!)
            
        // Filter to avoid audios/songs from cloud library.
        let cloudFilter = MPMediaPropertyPredicate(
            value: false,
            forProperty: MPMediaItemPropertyIsCloudItem
        )
        cursor?.addFilterPredicate(cloudFilter)
            
        // Query everything in background for a better performance.
        loadArtwork(cursor: cursor, size: size, format: format, uri: uri, quality: quality)
    }
    
    private func loadArtwork(cursor: MPMediaQuery!, size: Int, format: Int, uri: Int, quality: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            var artwork: Data?
            var item: MPMediaItem?
            let convertedQuality = CGFloat(Double(quality) / 100.0)
            
            // 'uri' == 0         -> artwork is from [Song]
            // 'uri' == 1, 2 or 3 -> artwork is from [Album], [Playlist] or [Artist]
            if uri == 0 {
                item = cursor!.items?.first
            } else {
                item = cursor!.collections?.first?.items[0]
            }
            
            let cgSize = CGSize(width: size, height: size)
            let image: UIImage? = item?.artwork?.image(at: cgSize)
            
            // 'format' == 0 -> JPEG
            // 'format' == 1 -> PNG
            if format == 0 {
                artwork = image?.jpegData(compressionQuality: convertedQuality)
            } else {
                // [PNG] format will return a high quality image.
                artwork = image?.pngData()
            }
            
            DispatchQueue.main.async {
                // Avoid "empty" or broken image.
                if artwork != nil, artwork!.isEmpty {
                    if PluginProvider.showDetailedLog {
                        Log.type.warning("Item (\(item?.persistentID ?? 0)) has a null or empty artwork")
                    }
                    artwork = nil
                }
                
                self.result(artwork)
            }
        }
    }
}
