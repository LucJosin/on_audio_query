## [1.1.2] - [07.07.2021]
### Fixes
#### Kotlin
- Fixed `[cursor]` problem when using `[AudiosFromType.GENRE_NAME]` or `[AudiosFromType.GENRE_ID]` on `[queryAudiosFrom]`. - [Fixed #12](https://github.com/LucasPJS/on_audio_query/issues/12)

### Documentation
- Updated `README` documentation.

## [1.1.1] - [06.23.2021]
### Features
#### Dart/Kotlin
- Added `[uri]` to `[SongModel]`. - [Added #10](https://github.com/LucasPJS/on_audio_query/issues/10)

### Fixes
#### Kotlin
- Fixed `java.lang.Integer cannot be cast to java.lang.Long` from `[queryArtworks]`. - [Fixed #11](https://github.com/LucasPJS/on_audio_query/issues/11)

### Documentation
- Updated `README` documentation.
- Created `DEPRECATED` file/history.

### Changes
#### Dart
- Changed from `[deviceInfo]` to `[deviceSDK]` on `[QueryArtworkWidget]`.

### ⚠ Important Changes
#### Dart
- Deprecated `[deviceInfo]` from `[QueryArtworkWidget]`.

## [1.1.0] - [06.03.2021]
### Features
#### Dart/Kotlin
- Added `[queryDeviceInfo]`.
- Added `[dateModified]` to `[SongModel]`.
- Added `[querySongsBy]` and `[SongsByType]`.

### Fixes
#### Kotlin
- Fixed incompatibility with `[permission_handler]`. - [Fixed #3](https://github.com/LucasPJS/on_audio_query/issues/3) - Thanks [@mvanbeusekom](https://github.com/mvanbeusekom)

#### Dart
- Fixed wrong name. From `[dataAdded]` to `[dateAdded]`.

### Documentation
- Updated `README` documentation.
- Updated `[OnAudioQueryExample]` to add new `[queryDeviceInfo]` and `[QueryArtworkWidget]` methods.

### Changes
#### Kotlin
- Updated some `[Kotlin]` dependencies.
- Changed some `[Kotlin]` methods.

### ⚠ Important Changes
#### Dart
- Now `[getDeviceSDK]`, `[getDeviceRelease]` and `[getDeviceCode]` are part of `[queryDeviceInfo]`.
- Now `[QueryArtworkWidget]` support Android above and below 29/Q/10.
- Now `[size]`, `[albumId]`, `[artistId]`, `[dataAdded]`, `[dataModified]`, `[duration]`, `[track]` and `[year]` from `[SongModel]` will return `[int]`.

## [1.0.8] - [05.19.2021]
### Features
#### Dart
- Added `[artworkClipBehavior]`, `[keepOldArtwork]`, `[repeat]` and `[scale]` to `[QueryArtworkWidget]`.
- Added comments to `[QueryArtworkWidget]`.

### Fixes
#### Kotlin
- Now `[queryArtworks]` will return null. - [Fixed #6](https://github.com/LucasPJS/on_audio_query/issues/6)

### Documentation
- Updated `README` documentation.

### ⚠ Important Changes
#### Dart
- Now `[queryArtworks]` return `[Uint8List?]`.

## [1.0.7] - [05.18.2021]
### Features
#### Dart/Kotlin
- Added `[queryFromFolder]`.
- Added `[queryAllPath]`.
- Added `[_display_name_wo_ext]` (`[displayName]` without extension) to `[SongModel]`. - [Added #5](https://github.com/LucasPJS/on_audio_query/issues/5)
- Added `[file_extension]` (Only file extension) to `[SongModel]`.
- Added `[file_parent]` (All the path before file) to `[SongModel]`.
- Added `[Genre]` to `[queryAudiosFrom]`.
- Added `[ALBUM_ID]`, `[ARTIST_ID]` and `[PLAYLIST_ID]` to `[AudiosFromType]`. - [Added #2](https://github.com/LucasPJS/on_audio_query/issues/2)

### Documentation
- Updated `README` documentation.

### Changes
#### Dart/Kotlin
- Now `[queryAudiosFrom]` supports `[name]` and `[id]`.
- Now `[albumId]` from `[AlbumModel]` return a `[int]`.

#### Kotlin
- Now all `[Kotlin]` checks will throw a `[Exception]` if value don't exist.
- Updated some `[Kotlin]` dependencies.

### ⚠ Important Changes
#### Dart/Kotlin
- Changed `[ALBUM]`, `[ARTIST]` and `[PLAYLIST]` to `[ALBUM_NAME]`, `[ARTIST_NAME]` and `[PLAYLIST_NAME]` in `[AudiosFromType]`.

## [1.0.6] - [04.08.2021]
### Fixes
#### Kotlin
- Fixed `[queryArtwork]` returning null album image in Android 11. - [Fixed #1](https://github.com/LucasPJS/on_audio_query/issues/1)

### Documentation
- Updated `README` documentation.

### Changes
#### Kotlin
- Removed unnecessary code from `[WithFiltersType]`.
- Updated some `[Kotlin]` dependencies.

## [1.0.5] - [03.31.2021]
### Features
#### Dart/Kotlin
- Added `[queryAudiosOnly]`.
- Added `[queryWithFilters]`.
- Added `[AudiosOnlyType]` and `[WithFiltersType]`.
- Added `[SongsArgs]`, `[AlbumsArgs]`, `[PlaylistsArgs]`, `[ArtistsArgs]`, `[GenresArgs]`.
- Added `[EXTERNAL]` and `[INTERNAL]` parameters for some query methods.

### Documentation
- Updated `README` documentation.

### Changes
#### Dart/Kotlin
- Now `[querySongs]`, `[queryAlbums]`, `[queryArtists]`, `[queryPlaylists]` and `[queryGenres]` have `[UriType]` as parameter.

#### Kotlin
- Updated some `[Kotlin]` dependencies.

## [1.0.3] - [03.28.2021]
### ⚠ Important Changes
#### Dart
- Migrate to null safety.

## [1.0.2] - [03.27.2021]
### Fixes
#### Dart
- Fixed flutter example.

#### Kotlin
- Fixed `[audiosFromPlaylist]` [**Now this method is part of queryAudiosFrom**]
- Fixed `"count(*)"` error from `[addToPlaylist]`. [**Permission bug on Android 10 still happening**]

### Documentation
- Updated `README` documentation.

### Changes
#### Dart
- Now `[Id]` in models return `[int]` instead `[String]`.

### ⚠ Important Changes
#### Dart/Kotlin
- Removed `[ALBUM_KEY]`, `[ARTIST_KEY]` from all query audio methods.

#### Kotlin
- Moved `[audiosFromPlaylist]` to `[queryAudiosFrom]`.

## [1.0.0] - [03.24.2021]
### Release

- `[on_audio_query]` release.

## [0.5.0] - [03.23.2021]
### Features
#### Dart/Kotlin
- Changed some methods extructure.
- Added `[moveItemTo]` method to Playlist.
- Added `[Size]` and `[Format]` parameters to `[queryArtwork]`.
- Added `[getDeviceSDK]`, `[getDeviceRelease]` and `[getDeviceCode]`.
- Added `[retryRequest]` parameter to `[permissionsRequest]`.

#### Dart
- Added `[QueryArtworkWidget]`.

### Fixes
- Added paramerer `[AudioId]` to `[addToPlaylist]` and `[removeFromPlaylist]`.

### Documentation
- Updated `README` documentation.
- Added more comments to `[Kotlin]` and `[Dart]` code.

### Changes
- Now Playlist methods parameters request `[id]` instead Name.
- Now `[renamePlaylist]` add more information -> `[Date_Modified]`.
- Now when `[requestPermission]` parameter is set to true or `[permissionsRequest]` method is called, both `[READ]` and `[WRITE]` is requested.

## [0.4.0] - [03.18.2021]
### Features
#### Dart/Kotlin
- Changed some methods extructure.
- Added `[renamePlaylist]`.
- Added separate option for sortType order `[ASC_OR_SMALLER]` and `[DESC_OR_GREATER]`.
- Added `[permissionsStatus]` and `[permissionsRequest]`.

### Documentation
- Updated `README` documentation.
- Added some comments to `[Kotlin]` and `[Dart]` code.

### Changes
- Now `[createPlaylist]`, `[removePlaylist]`, `[addToPlaylist]` and `[removeFromPlaylist]` return bool.

## [0.3.0] - [03.16.2021]
### Features
#### Dart/Kotlin
- Added `[createPlaylist]`, `[removePlaylist]`, `[addToPlaylist]` and `[removeFromPlaylist]`.

#### Dart
- Updated the `[Example]` application.

### Documentation
- Updated `README` documentation.

## [0.2.5] - [03.11.2021]
### Features
#### Dart/Kotlin
- Added `[queryArtworks]` and `[queryAudiosFrom]`.

### Fixes
- Added a better performace for query images.

### Documentation
- Updated `README` documentation.

## [0.2.0] - [03.10.2021]
### Features
#### Dart/Kotlin
- Added `[queryArtists]`, `[queryPlaylists]` and `[queryGenres]`.
- Added `[ArtistSortType]`, `[PlaylistsSortType]` and `[GenreSortType]`.

#### Kotlin
- Now all methods use `Kotlin Coroutines` for query in background, adding a better performace.

### Documentation
- Updated `README` documentation.
- Updated `pubspec.yaml`.
- Created `README` translation section.
- Created `README` translation for `pt-BR` [Portuguese].

## [0.1.5] - [03.08.2021]
### Features
#### Dart/Kotlin
- Added `[querySongs]`, `[queryAudio]` and `[queryAlbums]`.
- Added `[AudioSortType]` and `[AlbumSortType]`.

#### Kotlin
- Added `[Optional]` and `[Built-in]` Write and Read Storage Permission.

### Documentation
- Created a `README` documentation.

## [0.0.1] - [02.16.2021]
### Features
#### Dart/Kotlin
- Created the base for the plugin.

<!-- 
## [Version] - [Date]
### Features
- TODO

### Fixes
- TODO

### Documentation
- TODO

### Changes
- TODO

### ⚠ Important Changes
- TODO
 -->

<!-- 
 - [Added #Issue](Link)
 - [Fixed #Issue](Link)
 - [Changed #Issue](Link)
-->
