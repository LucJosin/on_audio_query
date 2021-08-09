import Flutter
import MediaPlayer

class OnWithFiltersQuery {
    var args: [String: Any]
    var result: FlutterResult
    
    init(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.args = call.arguments as! [String: Any]
        self.result = result
    }
    
    func queryWithFilters() {
        let withType = args["withType"] as! Int
        let arg = args["args"] as! Int
        let argVal = args["argsVal"] as! String
        var cursor: MPMediaQuery? = nil
            var filter: MPMediaPropertyPredicate? = nil
            switch withType {
            case 0:
                cursor = MPMediaQuery.songs()
                filter = checkSongsArgs(args: arg, argsVal: argVal)
            case 1:
                cursor = MPMediaQuery.albums()
                filter = checkAlbumsArgs(args: arg, argsVal: argVal)
            case 2:
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
            if filter != nil && withType != 2 {
                cursor?.addFilterPredicate(filter!)
                loadItemsWithFilter(cursor: cursor!, type: withType)
            } else {
                loadPlaylistsWithFilter(cursor: cursor!.collections, argVal: argVal)
            }
    }
    
    internal func loadItemsWithFilter(cursor: MPMediaQuery, type: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfItems: [[String: Any?]] = Array()
            
            if type == 0 {
                for song in cursor.items! {
                    let songData = loadSongItem(song: song)
                    listOfItems.append(songData)
                }
            } else {
                for item in cursor.collections! {
                    var itemData: [String: Any?] = [:]
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
                    listOfItems.append(itemData)
                }
            }
            
            DispatchQueue.main.async {
                self.result(listOfItems)
            }
        }
    }
    
    internal func loadPlaylistsWithFilter(cursor: [MPMediaItemCollection]!, argVal: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfPlaylist: [[String: Any?]] = Array()
            
            for playlist in cursor {
                var playlistData: [String: Any?] = [:]
                let iPlaylist = playlist as! MPMediaPlaylist
                if iPlaylist.name!.contains(argVal) {
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
