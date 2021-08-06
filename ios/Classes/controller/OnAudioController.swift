import Flutter

public class OnAudioController {
    var call: FlutterMethodCall
    var result: FlutterResult
    
    init(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.call = call
        self.result = result
    }
    
    public func chooseMethod() {
        switch call.method {
        case "querySongs":
            OnAudioQuery(call: call, result: result).querySongs()
        case "queryAlbums":
            OnAlbumsQuery(call: call, result: result).queryAlbums()
        case "queryArtists":
            OnArtistsQuery(call: call, result: result).queryArtists()
        case "queryGenres":
            OnGenresQuery(call: call, result: result).queryGenres()
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
