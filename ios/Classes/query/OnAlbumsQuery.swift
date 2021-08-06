import Flutter
import MediaPlayer

class OnAlbumsQuery {
    var args: [String: Any]
    var result: FlutterResult
    
    init(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.args = call.arguments as! [String: Any]
        self.result = result
    }
    
    func queryAlbums() {
        let sortType = args["sortType"] as! Int
        
        let cursor = MPMediaQuery.albums()
        cursor.groupingType = checkAlbumSortType(sortType: sortType)
        loadAlbums(cursor: cursor.collections)
    }
    
    internal func loadAlbums(cursor: [MPMediaItemCollection]!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfAlbums: [[String: Any?]] = Array()
            
            for album in cursor {
                let albumData = loadAlbumItem(album: album)
                listOfAlbums.append(albumData)
            }
            
            DispatchQueue.main.async {
                let finalList = formatAlbumList(args: self.args, allAlbums: listOfAlbums)
                self.result(finalList)
            }
        }
    }
}
