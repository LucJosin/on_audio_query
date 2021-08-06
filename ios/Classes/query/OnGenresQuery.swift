import Flutter
import MediaPlayer

class OnGenresQuery {
    var args: [String: Any]
    var result: FlutterResult
    
    init(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.args = call.arguments as! [String: Any]
        self.result = result
    }
    
    func queryGenres() {
        let cursor = MPMediaQuery.genres()
        loadGenres(cursor: cursor.collections)
    }
    
    internal func loadGenres(cursor: [MPMediaItemCollection]!) {
        DispatchQueue.global(qos: .userInitiated).async {
            var listOfGenres: [[String: Any?]] = Array()
            
            for genre in cursor {
                let genreData = loadGenreItem(genre: genre)
                listOfGenres.append(genreData)
            }
            
            DispatchQueue.main.async {
                let finalList = formatGenreList(args: self.args, allGenres: listOfGenres)
                self.result(finalList)
            }
        }
    }
}
