import Flutter
import MediaPlayer

class WithFiltersQuery {
    var args: [String: Any]
    var result: FlutterResult
    
    init() {
        self.args = try! PluginProvider.call().arguments as! [String: Any]
        self.result = try! PluginProvider.result()
    }
    
    func queryWithFilters() {
        // None of this arguments can be null.
        // The [type] will be used to define where item will be queried.
        let withType = args["withType"] as! Int
        
        // The [arg] will be used to define the "search".
        let arg = args["args"] as! Int
        
        // The [argVal] is the "name" to the "search"
        let argVal = args["argsVal"] as! String
        
        // (To match android side, let's call "cursor").
        var cursor: MPMediaQuery?
        var filter: MPMediaPropertyPredicate?
        
        // Use the [type] to define the query.
        switch withType {
        case 0:
            cursor = MPMediaQuery.songs()
            filter = checkSongsArgs(args: arg, argsVal: argVal)
        case 1:
            cursor = MPMediaQuery.albums()
            filter = checkAlbumsArgs(args: arg, argsVal: argVal)
        case 2:
            // To query the playlist we need a different approach.
            // So, filter will be null.
            cursor = MPMediaQuery.playlists()
        case 3:
            cursor = MPMediaQuery.artists()
            filter = checkArtistsArgs(args: arg, argsVal: argVal)
        case 4:
            cursor = MPMediaQuery.genres()
            filter = checkGenresArgs(args: arg, argsVal: argVal)
        default:
            break
        }
        
        Log.type.debug("Query config: ")
        Log.type.debug("\twithType: \(withType)")
        Log.type.debug("\targ: \(arg)")
        Log.type.debug("\targVal: \(argVal)")
        Log.type.debug("\tcursor: \(String(describing: cursor))")
        Log.type.debug("\tfilter: \(String(describing: filter))")
        
        // Choose between query [Playlist] or others.
        if filter != nil, withType != 2 {
            // Add the filter.
            cursor?.addFilterPredicate(filter!)
                
            // Ignore cloud items.
            let cloudFilter = MPMediaPropertyPredicate(
                value: false,
                forProperty: MPMediaItemPropertyIsCloudItem
            )
            cursor?.addFilterPredicate(cloudFilter)
                
            // Query everything in background for a better performance.
            loadItemsWithFilter(cursor: cursor!, type: withType)
        } else {
            // Ignore cloud items.
            let cloudFilter = MPMediaPropertyPredicate(
                value: false,
                forProperty: MPMediaItemPropertyIsCloudItem
            )
            cursor?.addFilterPredicate(cloudFilter)
                
            // Query everything in background for a better performance.
            loadPlaylistsWithFilter(cursor: cursor!.collections, argVal: argVal)
        }
    }
    
    private func loadItemsWithFilter(cursor: MPMediaQuery, type: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfItems: [[String: Any?]] = Array()
            
            // 0 -> Song -> We use [MPMediaItem].
            // 1, 3 or 4 -> Album, Artist or Genre - We use [MPMediaItemCollection].
            if type == 0 {
                // For each item(song) inside this "cursor", take one and "format"
                // into a [Map<String, dynamic>], all keys are based on [Android]
                // platforms so, if you change some key, will have to change the [Android] too.
                for song in cursor.items! {
                    // If the song file don't has a assetURL, is a Cloud item.
                    if !song.isCloudItem, song.assetURL != nil {
                        let songData = loadSongItem(song: song)
                        listOfItems.append(songData)
                    }
                }
                //
            } else {
                // For each item inside "cursor", take one and choose between [Album],
                // [Artist] and [Genre], after this, "format" into a [Map<String, dynamic>],
                // all keys are based on [Android] platforms so, if you change some key, will
                // have to change the [Android] too.
                for item in cursor.collections! {
                    var itemData: [String: Any?] = [:]
                    // Ignore cloud items.
                    if !item.items[0].isCloudItem, item.items[0].assetURL != nil {
                        switch type {
                        case 1:
                            itemData = loadAlbumItem(album: item)
                        case 3:
                            itemData = loadArtistItem(artist: item)
                        case 4:
                            itemData = loadGenreItem(genre: item)
                        default:
                            break
                        }
                    }
                    listOfItems.append(itemData)
                }
            }
            
            DispatchQueue.main.async {
                self.result(listOfItems)
            }
        }
    }
    
    private func loadPlaylistsWithFilter(cursor: [MPMediaItemCollection]!, argVal: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfPlaylist: [[String: Any?]] = Array()
            
            // For each item(playlist) inside this "cursor", take one and check
            // if contains the defined argument, after this "format"
            // into a [Map<String, dynamic>], all keys are based on [Android]
            // platforms so, if you change some key, will have to change the [Android] too.
            for playlist in cursor {
                var playlistData: [String: Any?] = [:]
                let iPlaylist = playlist as! MPMediaPlaylist
                
                // Check if some playlist contains the defined argument.
                if iPlaylist.name!.contains(argVal), !iPlaylist.items[0].isCloudItem {
                    playlistData = loadPlaylistItem(playlist: playlist)
                }
                listOfPlaylist.append(playlistData)
            }
            
            DispatchQueue.main.async {
                self.result(listOfPlaylist)
            }
        }
    }
}
