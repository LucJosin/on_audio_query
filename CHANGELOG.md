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

### Important Changes
- TODO
 -->
