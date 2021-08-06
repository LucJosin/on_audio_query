import Flutter
import MediaPlayer

class OnArtistsQuery {
    var args: [String: Any]
    var result: FlutterResult
    
    init(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.args = call.arguments as! [String: Any]
        self.result = result
    }
    
    func queryArtists() {
//        let sortType = args["sortType"] as! Int
        
        let cursor = MPMediaQuery.artists()
//        cursor.groupingType = checkArtistSortType(sortType)
        loadArtists(cursor: cursor.collections)
    }
    
    internal func loadArtists(cursor: [MPMediaItemCollection]!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfArtists: [[String: Any?]] = Array()
            
            for artist in cursor {
                let artistData = loadArtistItem(artist: artist)
                listOfArtists.append(artistData)
            }
            
            DispatchQueue.main.async {
                let finalList = formatArtistList(args: self.args, allArtists: listOfArtists)
                self.result(finalList)
            }
        }
    }
}
