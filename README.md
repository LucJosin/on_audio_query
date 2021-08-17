# on_audio_query
[![Pub.dev](https://img.shields.io/pub/v/on_audio_query?color=9cf&label=Pub.dev&style=flat-square)](https://pub.dev/packages/on_audio_query)
[![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20IOS-9cf?&style=flat-square)]()
[![Languages](https://img.shields.io/badge/Languages-Flutter%20%7C%20Kotlin%20%7C%20Swift-9cf?&style=flat-square)]()

`on_audio_query` is a [Flutter](https://flutter.dev/) Plugin used to query audios/songs 🎶 infos [title, artist, album, etc..] from device storage. <br>

## Help:

**Any problem? [Issues](https://github.com/LucasPJS/on_audio_query/issues)** <br>
**Any suggestion? [Pull request](https://github.com/LucasPJS/on_audio_query/pulls)**

### Extensions:

<!-- * [on_audio_edit](https://github.com/LucasPJS/on_audio_edit) - Used to edit audio metadata. -->
* [on_audio_room](https://github.com/LucasPJS/on_audio_room) - Used to store audio [Favorites, Most Played, etc..].

### Translations:

NOTE: Feel free to help with readme translations

* [English](README.md)
* [Portuguese](README.pt-BR.md)

### Topics:

* [Gif Examples](#gif-examples)
* [How to Install](#how-to-install)
* [Platforms](#platforms)
* [How to use](#how-to-use)
* [Examples](#examples)
* [License](#license)

## Gif Examples:
| <img src="https://user-images.githubusercontent.com/76869974/129740857-33f38b27-06a3-4959-bb31-2ae97d6b66ff.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/129741012-1215b292-d700-466f-9c41-552df0ad5e89.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/129741188-e6803432-24d7-4e39-bfde-cc6765e13663.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/129741151-b820edc9-ddbf-4446-b67a-6e254cb5a46d.gif"/> |
|:---:|:---:|:---:|:---:|
| <img src="https://user-images.githubusercontent.com/76869974/129763885-c0cb3871-39af-45fa-aebf-ebf4113effa2.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/129763519-497cab72-6a95-42fd-8237-3f83e954ea50.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/129763577-9037d16f-f940-4bcb-ba37-879a0eecf2ac.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/129763551-726512a9-bc10-4c75-a167-8928f0c0c212.gif"/> |
| Songs | Albums | Playlists | Artists |

## Platforms:

<!-- ✔️ | ❌ | ⭕ -->
|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `querySongs` | `✔️` | `✔️` | <br>
| `queryAlbums` | `✔️` | `✔️` | <br>
| `queryArtists` | `✔️` | `✔️` | <br>
| `queryPlaylists` | `✔️` | `✔️` | <br>
| `queryGenres` | `✔️` | `✔️` | <br>
| `queryAudiosFrom` | `✔️` | `✔️` | <br>
| `queryWithFilters` | `✔️` | `✔️` | <br>
| `queryArtwork` | `✔️` | `✔️` | <br>
| `createPlaylist` | `✔️` | `✔️` | <br>
| `removePlaylist` | `✔️` | `⭕` | <br>
| `addToPlaylist` | `✔️` | `✔️` | <br>
| `removeFromPlaylist` | `✔️` | `⭕` | <br>
| `renamePlaylist` | `✔️` | `⭕` | <br>
| `moveItemTo` | `✔️` | `⭕` | <br>
| `permissionsRequest` | `✔️` | `✔️` | <br>
| `permissionsStatus` | `✔️` | `✔️` | <br>
| `queryDeviceInfo` | `✔️` | `✔️` | <br>

✔️ -> Supported <br>
❌ -> Not Supported <br>
⭕ -> Supported Partially/Platform Limitation

**[See all platforms methods support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)**

## How to Install:
Add the following code to your `pubspec.yaml`:
```yaml
dependencies:
  on_audio_query: ^2.0.0
```

### Request Permission:
#### Android:
To use this plugin add the following code to your `AndroidManifest.xml`
```xml
<manifest> ...

  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

</manifest>
```

#### IOS:
To use this plugin add the following code to your `Info.plist`
```
	<key>NSAppleMusicUsageDescription</key>
	<string>..Add a reason..</string>
```

## Some Features:

* Optional and Built-in storage `READ` and `WRITE` permission request
* Get all audios/songs.
* Get all albums and album-specific audios.
* Get all artists and artist-specific audios.
* Get all playlists and playlists-specific audios.
* Get all genres and genres-specific audios.
* Get all query methods with specific `keys` [Search].
* Create/Delete/Rename playlists.
* Add/Remove/Move specific audios to playlists.
* Specific sort types for all query methods.

## TODO:

* Add better performance for all plugin.
* Add support to Web/Windows/MacOs/Linux.
* Option to remove songs.
* Fix bugs.

## How to use:

```dart
OnAudioQuery() // The main method to start using the plugin.
```
All types of methods on this plugin:

### Query methods

|  Methods  |   Parameters   |   Return   |
|--------------|-----------------|-----------------|
| [`querySongs`](#querysongs) | `(SortType, OrderType, UriType, RequestPermission)` | `List<SongModel>` | <br>
| [`queryAlbums`](#queryalbums) | `(SortType, OrderType, UriType, RequestPermission)` | `List<AlbumModel>` | <br>
| [`queryArtists`](#queryartists) | `(SortType, OrderType, UriType, RequestPermission)` | `List<ArtistModel>` | <br>
| [`queryPlaylists`](#queryplaylists) | `(SortType, OrderType, UriType, RequestPermission)` | `List<PlaylistModel>` | <br>
| [`queryGenres`](#querygenres) | `(SortType, OrderType, UriType, RequestPermission)` | `List<GenreModel>` | <br>
| [`queryAudiosFrom`]() | `(Type, Where, RequestPermission)` | `List<SongModel>` | <br>
| [`queryWithFilters`](#queryWithFilters) | `(ArgsVal, WithFiltersType, Args, RequestPermission)` | `List<dynamic>` | <br>
| [`queryArtwork`](#queryArtwork) | `(Id, Type, Format, Size, RequestPermission)` | `Uint8List?` | <br>

### Playlist methods

|  Methods  |   Parameters   |   Return   |
|--------------|-----------------|-----------------|
| [`createPlaylist`]() | `(PlaylistName, RequestPermission)` | `bool` | <br>
| [`removePlaylist`]() | `(PlaylistId, RequestPermission)` | `bool` | <br>
| [`addToPlaylist`]() | **[NT-BG]**`(PlaylistId, AudioId, RequestPermission)` | `bool` | <br>
| [`removeFromPlaylist`]() | **[NT]**`(PlaylistId, AudioId, RequestPermission)` | `bool` | <br>
| [`renamePlaylist`]() | `(PlaylistId, NewName, RequestPermission)` | `bool` | <br>
| [`moveItemTo`]() | **[NT]**`(PlaylistId, From, To, RequestPermission)` | `bool` | <br>

### Permissions/Device methods

|  Methods  |   Parameters   |   Return   |
|--------------|-----------------|-----------------|
| [`permissionsRequest`]() | `(retryRequest)` | `bool` | <br>
| [`permissionsStatus`]() |  | `bool` | <br>
| [`queryDeviceInfo`]() |  | `DeviceModel` | <br>

### Artwork Widget

Now `[QueryArtworkWidget]` support all Android versions.

```dart
  Widget someOtherName() async {
    return QueryArtworkWidget(
      id: SongId, 
      type: ArtworkType.AUDIO,
    );
  }
```

**See more: [QueryArtworkWidget](https://pub.dev/documentation/on_audio_query/latest/on_audio_query/QueryArtworkWidget-class.html)**

### Abbreviations

**[NT]** -> Need Tests <br>
**[BG]** -> Bug on Android 10/Q

## Examples:

#### querySongs
```dart
  someName() async {
    // DEFAULT: 
    // SongSortType.TITLE, 
    // OrderType.ASC_OR_SMALLER,
    // UriType.EXTERNAL, 
    List<SongModel> something = await OnAudioQuery().querySongs();
  }
```

#### queryAlbums
```dart
  someName() async {
    // DEFAULT: 
    // AlbumSortType.ALBUM, 
    // OrderType.ASC_OR_SMALLER 
    List<AlbumModel> something = await OnAudioQuery().queryAlbums();
  }
```

#### queryArtists
```dart
  someName() async {
    // DEFAULT: 
    // ArtistSortType.ARTIST, 
    // OrderType.ASC_OR_SMALLER 
    List<ArtistModel> something = await OnAudioQuery().queryArtists();
  }
```

#### queryPlaylists
```dart
  someName() async {
    // DEFAULT: 
    // PlaylistSortType.NAME, 
    // OrderType.ASC_OR_SMALLER 
    List<PlaylistModel> something = await OnAudioQuery().queryPlaylists();
  }
```

#### queryGenres
```dart
  someName() async {
    // DEFAULT: 
    // GenreSortType.NAME, 
    // OrderType.ASC_OR_SMALLER 
    List<GenreModel> something = await OnAudioQuery().queryGenres();
  }
```

#### queryArtwork
⚠ **Note: Only works in Android >= Q/10**
```dart
  someName() async {
    // DEFAULT: ArtworkFormat.JPEG, 200 and false
    Uint8List something = await OnAudioQuery().queryArtwork(
        SongId, 
        ArtworkType.AUDIO, 
        ...,
      );
  }
```

Or you can use a basic and custom Widget.
**See example [QueryArtworkWidget](#queryartworkwidget)**

#### queryWithFilters
```dart
  someName() async {
    // DEFAULT: Args.TITLE and false
    // ArgsTypes: AudiosArgs, AlbumsArgs, PlaylistsArgs, ArtistsArgs, GenresArgs
    List<dynamic> something = await OnAudioQuery().queryWithFilters(
        "Sam Smith", 
        WithFiltersType.ARTISTS,
      );

    // After getting the result from [queryWithFilters], convert this list using:
    List<TypeModel> convertedList = something.toTypeModel();

    // Example:
    List<SongModel> convertedSongs = something.toArtistModel(); 
  }
```

## LICENSE:

* [LICENSE](https://github.com/LucasPJS/on_audio_query/blob/main/LICENSE)

> * [Back to top](#on_audio_query)
