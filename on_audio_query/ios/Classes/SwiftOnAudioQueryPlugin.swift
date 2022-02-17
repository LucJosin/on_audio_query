import Flutter
import UIKit
import MediaPlayer

public class SwiftOnAudioQueryPlugin: NSObject, FlutterPlugin {
    
    // Observers
    private var songsObserver: SongsObserver? = nil
    private var albumsObserver: AlbumsObserver? = nil
    private var artistsObserver: ArtistsObserver? = nil
    private var playlistsObserver: PlaylistsObserver? = nil
    private var genresObserver: GenresObserver? = nil
    
    // Dart <-> Swift communication.
    public static func register(with registrar: FlutterPluginRegistrar) {
        // Setup the method channel communication.
        let channel = FlutterMethodChannel(
            name: "com.lucasjosino.on_audio_query",
            binaryMessenger: registrar.messenger()
        )
        let instance = SwiftOnAudioQueryPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // Setup all event channel communication.
        instance.setUpEventChannel(binary: registrar.messenger())
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        // This is a basic permission handler, will return [true] if has permission and
        // [false] if don't.
        //
        // The others status will be ignored and replaced with [false].
        case "permissionsStatus":
            result(checkPermission())
        // The same as [permissionStatus], this is a basic permission handler and will only
        // return [true] or [false].
        //
        // When adding the necessary [permissions] inside [Info.plist], [IOS] will automatically
        // request but, in any case, you can call this method.
        case "permissionsRequest":
            MPMediaLibrary.requestAuthorization { status in
                if (status == .authorized) {
                    result(true)
                } else {
                    result(false)
                }
            }
        // Some basic information about the platform, in this case, [IOS]
        //   * Model (Only return the "type", like: IPhone, MacOs, IPod..)
        //   * Version (IOS version)
        //   * Type (IOS)
        case "queryDeviceInfo":
            result(
                [
                    "device_model": UIDevice.current.model,
                    "device_sys_type": UIDevice.current.systemName,
                    "device_sys_version": UIDevice.current.systemVersion,
                ]
            )
        case "observersStatus":
            result(
                [
                    "songs_observer": songsObserver?.isRunning ?? false,
                    "albums_observer": albumsObserver?.isRunning ?? false,
                    "artists_observer": artistsObserver?.isRunning ?? false,
                    "playlists_observer": playlistsObserver?.isRunning ?? false,
                    "genres_observer": genresObserver?.isRunning ?? false,
                ]
            )
        default:
            // All others methods
            QueryController(call: call, result: result).chooseMethod()
        }
    }
    
    public func checkPermission() -> Bool {
        let permissionStatus = MPMediaLibrary.authorizationStatus()
        if permissionStatus == MPMediaLibraryAuthorizationStatus.authorized {
            return true
        } else {
            return false
        }
    }
    
    private func setUpEventChannel(binary: FlutterBinaryMessenger) {
        // Songs channel.
        let songsChannel = FlutterEventChannel(
            name: "com.lucasjosino.on_audio_query/songs_observer",
            binaryMessenger: binary
        )
        songsObserver = SongsObserver()
        songsChannel.setStreamHandler(songsObserver)
        
        // Albums channel.
        let albumsChannel = FlutterEventChannel(
            name: "com.lucasjosino.on_audio_query/albums_observer",
            binaryMessenger: binary
        )
        albumsObserver = AlbumsObserver()
        albumsChannel.setStreamHandler(albumsObserver)
        
        // Artists channel.
        let artistsChannel = FlutterEventChannel(
            name: "com.lucasjosino.on_audio_query/artists_observer",
            binaryMessenger: binary
        )
        artistsObserver = ArtistsObserver()
        artistsChannel.setStreamHandler(artistsObserver)
        
        // Playlists channel.
        let playlistsChannel = FlutterEventChannel(
            name: "com.lucasjosino.on_audio_query/playlists_observer",
            binaryMessenger: binary
        )
        playlistsObserver = PlaylistsObserver()
        playlistsChannel.setStreamHandler(playlistsObserver)
        
        // Genres channel.
        let genresChannel = FlutterEventChannel(
            name: "com.lucasjosino.on_audio_query/genres_observer",
            binaryMessenger: binary
        )
        genresObserver = GenresObserver()
        genresChannel.setStreamHandler(genresObserver)
    }
}
