# on_audio_query
<!-- https://img.shields.io/badge/Platform-Android%20%7C%20IOS-9cf?&style=flat-square -->
[![Pub.dev](https://img.shields.io/pub/v/on_audio_query?color=9cf&label=Pub.dev&style=flat-square)](https://pub.dev/packages/on_audio_query)
[![Platform](https://img.shields.io/badge/Platform-Android-9cf?logo=android&style=flat-square)](https://www.android.com/)
[![Flutter](https://img.shields.io/badge/Language-Flutter%20%7C%20Null--Safety-9cf?logo=flutter&style=flat-square)](https://www.flutter.dev/)
[![Kotlin](https://img.shields.io/badge/Language-Kotlin-9cf?logo=kotlin&style=flat-square)](https://kotlinlang.org/)
<!-- [![LucasPJS](./banner.png)](https://github.com/LucasPJS) -->

`on_audio_query` is a [Flutter](https://flutter.dev/) Plugin used to query audios/songs 🎶 infos [title, artist, album, etc..] from device storage. <br>

## Help:

**Any problem? [Issues](https://github.com/LucasPJS/on_audio_query/issues)** <br>
**Any suggestion? [Pull request](https://github.com/LucasPJS/on_audio_query/pulls)**

### Extensions:

* [on_audio_edit](https://github.com/LucasPJS/on_audio_edit) - Used to edit audio metadata.
* [on_audio_room](https://github.com/LucasPJS/on_audio_room) - Used to store audio [Favorites, Most Played, etc..].

### Translations:

NOTE: Feel free to help with readme translations

* [English](README.md)
* [Portuguese](README.pt-BR.md)

### Topics:

* [Gif Examples](#gif-examples)
* [How to Install](#how-to-install)
* [How to use](#how-to-use)
* [Examples](#examples)
* [License](#license)

## Gif Examples:
| <img src="https://user-images.githubusercontent.com/76869974/112378123-522c1a00-8cc5-11eb-880d-ba67706c415d.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/112378181-62dc9000-8cc5-11eb-8cb3-c8db71372fa9.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/112378214-6e2fbb80-8cc5-11eb-996a-d61bb8a620ca.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/112378250-7687f680-8cc5-11eb-94a1-ea91868d119c.gif"/> |
|:---:|:---:|:---:|:---:|
| Songs | Albums | Playlists | Artists |

## How to Install:
Add the following code to your `pubspec.yaml`:
```yaml
dependencies:
  on_audio_query: ^1.1.2
```

#### Request Permission:
If you want to use the built-in request permission, will need add the following code to your `AndroidManifest.xml`
```xml
<manifest> ...

  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

</manifest>
```

## Some Features:

* Optional and Built-in storage `READ` and `WRITE` permission request
* Get all audios and audios classified with `is_music`.
* Get all albums and album-specific audios.
* Get all artists and artist-specific audios.
* Get all playlists and playlists-specific audios.
* Get all genres and genres-specific audios.
* Get all folders and specific audios.
* Get all query methods with specific keys [Search].
* Create/Delete/Rename playlists.
* Add/Remove/Move specific audios to playlists.
* Specific sort types for all query methods.

## TODO:

* Add better performance for all plugin.
* Create methods for IOS.
* Option to remove songs.
* Fix bugs.

## How to use:

```dart
OnAudioQuery() // The main method to start using the plugin.
```
All types of methods on this plugin:

|  Methods  |   Parameters   |   Return   |
|--------------|-----------------|-----------------|
| [`querySongs`](#querysongs) | `(SortType, OrderType, UriType, RequestPermission)` | `List<SongModel>` | <br>
| [`queryAudio`]() | `(SortType, OrderType, UriType, RequestPermission)`. | `List<SongModel>` | <br>
| [`queryAlbums`](#queryalbums) | `(SortType, OrderType, UriType, RequestPermission)` | `List<AlbumModel>` | <br>
| [`queryArtists`](#queryartists) | `(SortType, OrderType, UriType, RequestPermission)` | `List<ArtistModel>` | <br>
| [`queryPlaylists`](#queryplaylists) | `(SortType, OrderType, UriType, RequestPermission)` | `List<PlaylistModel>` | <br>
| [`queryGenres`](#querygenres) | `(SortType, OrderType, UriType, RequestPermission)` | `List<GenreModel>` | <br>
| [`queryAudiosFrom`]() | `(Type, Where, RequestPermission)` | `List<SongModel>` | <br>
| [`queryAudiosOnly`](#queryAudiosOnly) | `(Type, Where, AudiosOnlyType, RequestPermission)` | `List<SongModel>` | <br>
| [`querySongsBy`]() | `(SongsByType, Values, UriType, RequestPermission)` | `List<SongModel>` | <br>
| [`queryWithFilters`](#queryWithFilters) | `(ArgsVal, WithFiltersType, Args, RequestPermission)` | `List<dynamic>` | <br>
| [`queryArtworks`](#queryArtworks) | `(Id, Type, Format, Size, RequestPermission)` | `Uint8List?` | <br>
| [`queryFromFolder`]() | `(Path, SortType, OrderType, UriType, RequestPermission)`. | `List<SongModel>` | <br>
| [`queryAllPath`]() |  | `List<String>` | <br>
| [`createPlaylist`]() | `(PlaylistName, RequestPermission)` | `bool` | <br>
| [`removePlaylist`]() | `(PlaylistId, RequestPermission)` | `bool` | <br>
| [`addToPlaylist`]() | **[NT-BG]**`(PlaylistId, AudioId, RequestPermission)` | `bool` | <br>
| [`removeFromPlaylist`]() | **[NT]**`(PlaylistId, AudioId, RequestPermission)` | `bool` | <br>
| [`renamePlaylist`]() | `(PlaylistId, NewName, RequestPermission)` | `bool` | <br>
| [`moveItemTo`]() | **[NT]**`(PlaylistId, From, To, RequestPermission)` | `bool` | <br>
| [`permissionsRequest`]() | `(retryRequest)` | `bool` | <br>
| [`permissionsStatus`]() |  | `bool` | <br>
| [`queryDeviceInfo`]() |  | `DeviceModel` | <br>

**Note: Some query methods require the `SortType` and `RequestPermisson`, by default, will be set `DEFAULT` and `false`**
**See all defaults sorttypes in [Examples](#examples)**

**[NT]** -> Need Tests <br>
**[BG]** -> Bug on Android 10/Q

## Examples:

#### querySongs
```dart
  someName() async {
    //DEFAULT: SongSortType.TITLE, OrderType.ASC_OR_SMALLER, UriType.EXTERNAL and false
    var something = await OnAudioQuery().querySongs();
  }
```

#### queryAlbums
```dart
  someName() async {
    //DEFAULT: AlbumSortType.ALBUM, OrderType.ASC_OR_SMALLER and false
    var something = await OnAudioQuery().queryAlbums();
  }
```

#### queryArtists
```dart
  someName() async {
    //DEFAULT: ArtistSortType.ARTIST, OrderType.ASC_OR_SMALLER and false
    var something = await OnAudioQuery().queryArtists();
  }
```

#### queryPlaylists
```dart
  someName() async {
    //DEFAULT: PlaylistSortType.NAME, OrderType.ASC_OR_SMALLER and false
    var something = await OnAudioQuery().queryPlaylists();
  }
```

#### queryGenres
```dart
  someName() async {
    //DEFAULT: GenreSortType.NAME, OrderType.ASC_OR_SMALLER and false
    var something = await OnAudioQuery().queryGenres();
  }
```

#### queryArtworks
⚠ **Note: Only works in Android >= Q/10**
```dart
  someName() async {
    //DEFAULT: ArtworkFormat.JPEG, 200 and false
    var something = await OnAudioQuery().queryArtworks(SongId, ArtworkType.AUDIO, ...)
  }
```

Or you can use a basic and custom Widget.
**See example [QueryArtworkWidget](#queryartworkwidget)**

#### queryAudiosOnly
⚠ Note: Some Types only exist in Android >= Q/10, if you try call them Android below Q/10 will return all types. <br>
⚠ See more in [Documentation](https://pub.dev/documentation/on_audio_query/latest/on_audio_query/OnAudioQuery/queryAudiosOnly.html)
```dart
  someName() async {
    //DEFAULT: SongSortType.TITLE, OrderType.ASC_OR_SMALLER and false
    var something = await OnAudioQuery().queryAudiosOnly(AudiosOnlyType.IS_AUDIOBOOK);
  }

  someOtherName() async {
    //DEFAULT: SongSortType.TITLE, OrderType.ASC_OR_SMALLER and false
    var something = await OnAudioQuery().queryAudiosOnly(AudiosOnlyType.IS_PODCAST);
  }
```

#### queryWithFilters
⚠ Note: Args are defined with `[dynamic]` but will only work if you use correct Types. <br>
⚠ See more in [Documentation](https://pub.dev/documentation/on_audio_query/latest/on_audio_query/on_audio_query-library.html) -> Enums
```dart
  someName() async {
    //DEFAULT: Args.TITLE and false
    //ArgsTypes: AudiosArgs, AlbumsArgs, PlaylistsArgs, ArtistsArgs, GenresArgs
    var something = await OnAudioQuery().queryWithFilters("Sam Smith", WithFiltersType.ARTISTS);
  }
```

#### QueryArtworkWidget
Now `[QueryArtworkWidget]` support all Android versions.
```dart
  Widget someOtherName() async {
    DeviceModel deviceInfo = await OnAudioQuery().queryDeviceInfo();
    return QueryArtworkWidget(
      id: SongId, 
      type: ArtworkType.AUDIO,
      artwork: songList[index].artwork,
      deviceSDK: device.sdk,
    );
  }
```

**See more in [QueryArtworkWidget](https://pub.dev/documentation/on_audio_query/latest/on_audio_query/QueryArtworkWidget-class.html)**

## LICENSE:

* [LICENSE](https://github.com/LucasPJS/on_audio_query/blob/main/LICENSE)

> * [Back to top](#on_audio_query)
