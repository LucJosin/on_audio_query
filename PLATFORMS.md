# on_audio_query - Platforms support

Here you'll see a extra information about every method/type etc..

## Topics:

- [Methods](#methods)
- [Sort Types](#sorttypes)
  - [SongSortType](#songsorttype)
  - [AlbumSortType](#albumsorttype)
  - [ArtistSortType](#artistsorttype)
  - [PlaylistSortType](#playlistsorttype)
  - [GenreSortType](#genresorttype)
- [Order Types](#ordertypes)
- [Uri Types](#uritypes)
- [Artwork Types](#artworktype)
- [Artwork Format Types](#artworkformat)
- [Models](#models)
  - [SongModel](#songmodel)
  - [AlbumModel](#albummodel)
  - [PlaylistModel](#playlistmodel)
  - [ArtistModel](#artistmodel)
  - [GenreModel](#genremodel)
- [DeviceModel](#devicemodel)

✔️ -> Supported <br>
❌ -> Not Supported <br>

## Methods

| Methods              | Android | IOS  | Web  |
| -------------------- | ------- | ---- | ---- |
| `querySongs`         | `✔️`    | `✔️` | `✔️` |
| `queryAlbums`        | `✔️`    | `✔️` | `✔️` |
| `queryArtists`       | `✔️`    | `✔️` | `✔️` |
| `queryPlaylists`     | `✔️`    | `✔️` | `❌` |
| `queryGenres`        | `✔️`    | `✔️` | `✔️` |
| `queryArtwork`       | `✔️`    | `✔️` | `✔️` |
| `createPlaylist`     | `✔️`    | `✔️` | `❌` |
| `removePlaylist`     | `✔️`    | `❌` | `❌` |
| `addToPlaylist`      | `✔️`    | `✔️` | `❌` |
| `removeFromPlaylist` | `✔️`    | `❌` | `❌` |
| `renamePlaylist`     | `✔️`    | `❌` | `❌` |
| `moveItemTo`         | `✔️`    | `❌` | `❌` |
| `permissionsRequest` | `✔️`    | `✔️` | `❌` |
| `permissionsStatus`  | `✔️`    | `✔️` | `❌` |
| `queryDeviceInfo`    | `✔️`    | `✔️` | `✔️` |
| `scanMedia`          | `✔️`    | `❌` | `❌` |

## SortTypes

### SongSortType

| Methods        | Android | IOS  | Web  |
| -------------- | ------- | ---- | ---- |
| `DEFAULT`      | `✔️`    | `✔️` | `✔️` |
| `ARTIST`       | `✔️`    | `✔️` | `✔️` |
| `ALBUM`        | `✔️`    | `✔️` | `✔️` |
| `DURATION`     | `✔️`    | `✔️` | `✔️` |
| `DATA_ADDED`   | `✔️`    | `✔️` | `❌` |
| `SIZE`         | `✔️`    | `✔️` | `✔️` |
| `DISPLAY_NAME` | `✔️`    | `✔️` | `✔️` |

### AlbumSortType

| Methods        | Android | IOS  | Web  |
| -------------- | ------- | ---- | ---- |
| `DEFAULT`      | `✔️`    | `✔️` | `✔️` |
| `ARTIST`       | `✔️`    | `✔️` | `✔️` |
| `ALBUM`        | `✔️`    | `✔️` | `✔️` |
| `NUM_OF_SONGS` | `✔️`    | `✔️` | `✔️` |

### ArtistSortType

| Methods         | Android | IOS  | Web  |
| --------------- | ------- | ---- | ---- |
| `DEFAULT`       | `✔️`    | `❌` | `✔️` |
| `ARTIST_NAME`   | `✔️`    | `✔️` | `✔️` |
| `ARTIST_KEY`    | `✔️`    | `❌` | `❌` |
| `NUM_OF_TRACKS` | `✔️`    | `✔️` | `✔️` |
| `NUM_OF_ALBUMS` | `✔️`    | `✔️` | `✔️` |

### PlaylistSortType

| Methods         | Android | IOS  | Web  |
| --------------- | ------- | ---- | ---- |
| `DEFAULT`       | `✔️`    | `❌` | `❌` |
| `DATA_ADDED`    | `✔️`    | `❌` | `❌` |
| `PLAYLIST_NAME` | `✔️`    | `❌` | `❌` |

### GenreSortType

| Methods   | Android | IOS  | Web  |
| --------- | ------- | ---- | ---- |
| `DEFAULT` | `✔️`    | `✔️` | `✔️` |

## OrderTypes

| Methods | Android | IOS  | Web  |
| ------- | ------- | ---- | ---- |
| `ASC`   | `✔️`    | `✔️` | `✔️` |
| `DESC`  | `✔️`    | `✔️` | `✔️` |

## UriTypes

| Methods    | Android | IOS  | Web  |
| ---------- | ------- | ---- | ---- |
| `EXTERNAL` | `✔️`    | `❌` | `❌` |
| `INTERNAL` | `✔️`    | `✔️` | `✔️` |

## ArtworkTypes

| Methods | Android | IOS  | Web  |
| ------- | ------- | ---- | ---- |
| `AUDIO` | `✔️`    | `✔️` | `✔️` |
| `ALBUM` | `✔️`    | `✔️` | `✔️` |

## ArtworkFormat

| Methods | Android | IOS  | Web  |
| ------- | ------- | ---- | ---- |
| `JPEG`  | `✔️`    | `✔️` | `❌` |
| `PNG`   | `✔️`    | `✔️` | `❌` |

## Models

### SongModel

| Methods            | Android | IOS  | Web  |
| ------------------ | ------- | ---- | ---- |
| `id`               | `✔️`    | `✔️` | `✔️` |
| `data`             | `✔️`    | `✔️` | `✔️` |
| `uri`              | `✔️`    | `❌` | `❌` |
| `displayName`      | `✔️`    | `✔️` | `✔️` |
| `displayNameWOExt` | `✔️`    | `✔️` | `✔️` |
| `size`             | `✔️`    | `✔️` | `✔️` |
| `album`            | `✔️`    | `✔️` | `✔️` |
| `albumId`          | `✔️`    | `✔️` | `✔️` |
| `artist`           | `✔️`    | `✔️` | `✔️` |
| `artistId`         | `✔️`    | `✔️` | `✔️` |
| `genre`            | `✔️`    | `✔️` | `✔️` |
| `genreId`          | `✔️`    | `✔️` | `✔️` |
| `bookmark`         | `✔️`    | `✔️` | `❌` |
| `composer`         | `✔️`    | `✔️` | `❌` |
| `dateAdded`        | `✔️`    | `✔️` | `❌` |
| `dateModified`     | `✔️`    | `❌` | `✔️` |
| `duration`         | `✔️`    | `✔️` | `❌` |
| `title`            | `✔️`    | `✔️` | `✔️` |
| `track`            | `✔️`    | `✔️` | `✔️` |
| `fileExtension`    | `✔️`    | `✔️` | `✔️` |
| `is_alarm`         | `✔️`    | `❌` | `❌` |
| `is_audiobook`     | `✔️`    | `❌` | `❌` |
| `is_music`         | `✔️`    | `❌` | `❌` |
| `is_notification`  | `✔️`    | `❌` | `❌` |
| `is_podcast`       | `✔️`    | `❌` | `❌` |
| `is_ringtone`      | `✔️`    | `❌` | `❌` |

### AlbumModel

| Methods      | Android | IOS  | Web  |
| ------------ | ------- | ---- | ---- |
| `id`         | `✔️`    | `✔️` | `✔️` |
| `album`      | `✔️`    | `✔️` | `✔️` |
| `albumId`    | `✔️`    | `✔️` | `✔️` |
| `artist`     | `✔️`    | `✔️` | `✔️` |
| `artistId`   | `✔️`    | `✔️` | `✔️` |
| `numOfSongs` | `✔️`    | `✔️` | `✔️` |

### PlaylistModel

| Methods        | Android | IOS  | Web  |
| -------------- | ------- | ---- | ---- |
| `id`           | `✔️`    | `✔️` | `❌` |
| `playlist`     | `✔️`    | `✔️` | `❌` |
| `data`         | `✔️`    | `❌` | `❌` |
| `dateAdded`    | `✔️`    | `✔️` | `❌` |
| `dateModified` | `✔️`    | `✔️` | `❌` |
| `numOfSongs`   | `✔️`    | `✔️` | `❌` |
| `artwork`      | `❌`    | `✔️` | `❌` |

### ArtistModel

| Methods          | Android | IOS  | Web  |
| ---------------- | ------- | ---- | ---- |
| `id`             | `✔️`    | `✔️` | `✔️` |
| `artist`         | `✔️`    | `✔️` | `✔️` |
| `numberOfAlbums` | `✔️`    | `✔️` | `✔️` |
| `numberOfTracks` | `✔️`    | `✔️` | `✔️` |

### GenreModel

| Methods      | Android | IOS  | Web  |
| ------------ | ------- | ---- | ---- |
| `id`         | `✔️`    | `✔️` | `✔️` |
| `genre`      | `✔️`    | `✔️` | `✔️` |
| `numOfSongs` | `✔️`    | `✔️` | `✔️` |

### DeviceModel

| Methods   | Android | IOS  | Web  |
| --------- | ------- | ---- | ---- |
| `version` | `✔️`    | `✔️` | `✔️` |
| `type`    | `✔️`    | `✔️` | `✔️` |
| `model`   | `✔️`    | `✔️` | `❌` |
