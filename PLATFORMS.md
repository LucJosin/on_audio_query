# on_audio_query - Platforms support

Here you'll see a extra information about every method/type etc..

## Topics:

- [Methods](#methods)
  - [Query Methods](#query-methods)
  - [Observer Methods](#observer-methods)
  - [Playlist Methods](#playlist-methods)
  - [Others Methods](#others-methods)
- [Sort Types](#sorttypes)
  - [AudioSortType](#audiosorttype)
  - [AlbumSortType](#albumsorttype)
  - [ArtistSortType](#artistsorttype)
  - [PlaylistSortType](#playlistsorttype)
  - [GenreSortType](#genresorttype)
- [Order Types](#ordertypes)
- [Uri Types](#uritypes)
- [Artwork Types](#artworktype)
- [Artwork Format Types](#artworkformat)
- [Models](#models)
  - [AudioModel](#audiomodel)
  - [AlbumModel](#albummodel)
  - [PlaylistModel](#playlistmodel)
  - [ArtistModel](#artistmodel)
  - [GenreModel](#genremodel)
  - [DeviceModel](#devicemodel)

✔️ -> Supported <br>
❌ -> Not Supported <br>

## Methods

### Query methods

|      Methods      | Android | IOS  | Web  | Windows |
| :---------------: | :-----: | :--: | :--: | :-----: |
|   `queryAudios`   |  `✔️`   | `✔️` | `✔️` |  `✔️`   |
|   `queryAlbums`   |  `✔️`   | `✔️` | `✔️` |  `✔️`   |
|  `queryArtists`   |  `✔️`   | `✔️` | `✔️` |  `✔️`   |
| `queryPlaylists`  |  `✔️`   | `✔️` | `❌` |  `❌`   |
|   `queryGenres`   |  `✔️`   | `✔️` | `✔️` |  `✔️`   |
|  `queryArtwork`   |  `✔️`   | `✔️` | `❌` |  `❌`   |
| `queryDeviceInfo` |  `✔️`   | `✔️` | `❌` |  `❌`   |

### Observer methods

|      Methods       | Android | IOS  | Web  | Windows |
| :----------------: | :-----: | :--: | :--: | :-----: |
|  `observeAudios`   |  `✔️`   | `✔️` | `❌` |  `✔️`   |
|  `observeAlbums`   |  `✔️`   | `✔️` | `❌` |  `✔️`   |
|  `observeArtists`  |  `✔️`   | `✔️` | `❌` |  `✔️`   |
| `observePlaylists` |  `✔️`   | `✔️` | `❌` |  `❌`   |
|  `observeGenres`   |  `✔️`   | `✔️` | `❌` |  `✔️`   |

### Playlist methods

|       Methods        | Android | IOS  | Web  | Windows |
| :------------------: | :-----: | :--: | :--: | :-----: |
|   `createPlaylist`   |  `✔️`   | `✔️` | `❌` |  `❌`   |
|   `removePlaylist`   |  `✔️`   | `❌` | `❌` |  `❌`   |
|   `addToPlaylist`    |  `✔️`   | `✔️` | `❌` |  `❌`   |
| `removeFromPlaylist` |  `✔️`   | `❌` | `❌` |  `❌`   |
|   `renamePlaylist`   |  `✔️`   | `❌` | `❌` |  `❌`   |
|     `moveItemTo`     |  `✔️`   | `❌` | `❌` |  `❌`   |

### Permission methods

|       Methods        | Android | IOS  | Web  | Windows |
| :------------------: | :-----: | :--: | :--: | :-----: |
| `permissionsRequest` |  `✔️`   | `✔️` | `❌` |  `❌`   |
| `permissionsStatus`  |  `✔️`   | `✔️` | `❌` |  `❌`   |

### Others methods

|      Methods      | Android | IOS  | Web  | Windows |
| :---------------: | :-----: | :--: | :--: | :-----: |
|    `scanMedia`    |  `✔️`   | `✔️` | `❌` |  `✔️`   |
| `observersStatus` |  `✔️`   | `✔️` | `❌` |  `✔️`   |

## SortTypes

### AudioSortType

|    Methods     | Android | IOS  | Web  |
| :------------: | :-----: | :--: | :--: |
|   `DEFAULT`    |  `✔️`   | `✔️` | `✔️` |
|    `ARTIST`    |  `✔️`   | `✔️` | `✔️` |
|    `ALBUM`     |  `✔️`   | `✔️` | `✔️` |
|   `DURATION`   |  `✔️`   | `✔️` | `✔️` |
|  `DATA_ADDED`  |  `✔️`   | `✔️` | `❌` |
|     `SIZE`     |  `✔️`   | `✔️` | `✔️` |
| `DISPLAY_NAME` |  `✔️`   | `✔️` | `✔️` |

### AlbumSortType

|    Methods     | Android | IOS  | Web  |
| :------------: | :-----: | :--: | :--: |
|   `DEFAULT`    |  `✔️`   | `✔️` | `✔️` |
|    `ARTIST`    |  `✔️`   | `✔️` | `✔️` |
|    `ALBUM`     |  `✔️`   | `✔️` | `✔️` |
| `NUM_OF_SONGS` |  `✔️`   | `✔️` | `✔️` |

### ArtistSortType

|     Methods     | Android | IOS  | Web  |
| :-------------: | :-----: | :--: | :--: |
|    `DEFAULT`    |  `✔️`   | `❌` | `✔️` |
|  `ARTIST_NAME`  |  `✔️`   | `✔️` | `✔️` |
|  `ARTIST_KEY`   |  `✔️`   | `❌` | `❌` |
| `NUM_OF_TRACKS` |  `✔️`   | `✔️` | `✔️` |
| `NUM_OF_ALBUMS` |  `✔️`   | `✔️` | `✔️` |

### PlaylistSortType

|     Methods     | Android | IOS  | Web  |
| :-------------: | :-----: | :--: | :--: |
|    `DEFAULT`    |  `✔️`   | `❌` | `❌` |
|  `DATA_ADDED`   |  `✔️`   | `❌` | `❌` |
| `PLAYLIST_NAME` |  `✔️`   | `❌` | `❌` |

### GenreSortType

|  Methods  | Android | IOS  | Web  |
| :-------: | :-----: | :--: | :--: |
| `DEFAULT` |  `✔️`   | `✔️` | `✔️` |

## OrderTypes

| Methods | Android | IOS  | Web  |
| :-----: | :-----: | :--: | :--: |
|  `ASC`  |  `✔️`   | `✔️` | `✔️` |
| `DESC`  |  `✔️`   | `✔️` | `✔️` |

## UriTypes

|  Methods   | Android | IOS  | Web  |
| :--------: | :-----: | :--: | :--: |
| `EXTERNAL` |  `✔️`   | `❌` | `❌` |
| `INTERNAL` |  `✔️`   | `✔️` | `✔️` |

## ArtworkTypes

| Methods | Android | IOS  | Web  |
| ------: | :-----: | :--: | :--: |
| `AUDIO` |  `✔️`   | `✔️` | `✔️` |
| `ALBUM` |  `✔️`   | `✔️` | `✔️` |

## ArtworkFormat

| Methods | Android | IOS  | Web  |
| :-----: | :-----: | :--: | :--: |
| `JPEG`  |  `✔️`   | `✔️` | `❌` |
|  `PNG`  |  `✔️`   | `✔️` | `❌` |

## Models

### SongModel

|      Methods       | Android | IOS  | Web  |
| :----------------: | :-----: | :--: | :--: |
|        `id`        |  `✔️`   | `✔️` | `✔️` |
|       `data`       |  `✔️`   | `✔️` | `✔️` |
|       `uri`        |  `✔️`   | `❌` | `❌` |
|   `displayName`    |  `✔️`   | `✔️` | `✔️` |
| `displayNameWOExt` |  `✔️`   | `✔️` | `✔️` |
|       `size`       |  `✔️`   | `✔️` | `✔️` |
|      `album`       |  `✔️`   | `✔️` | `✔️` |
|     `albumId`      |  `✔️`   | `✔️` | `✔️` |
|      `artist`      |  `✔️`   | `✔️` | `✔️` |
|     `artistId`     |  `✔️`   | `✔️` | `✔️` |
|      `genre`       |  `✔️`   | `✔️` | `✔️` |
|     `genreId`      |  `✔️`   | `✔️` | `✔️` |
|     `bookmark`     |  `✔️`   | `✔️` | `❌` |
|     `composer`     |  `✔️`   | `✔️` | `❌` |
|    `dateAdded`     |  `✔️`   | `✔️` | `❌` |
|   `dateModified`   |  `✔️`   | `❌` | `✔️` |
|     `duration`     |  `✔️`   | `✔️` | `❌` |
|      `title`       |  `✔️`   | `✔️` | `✔️` |
|      `track`       |  `✔️`   | `✔️` | `✔️` |
|  `fileExtension`   |  `✔️`   | `✔️` | `✔️` |
|     `is_alarm`     |  `✔️`   | `❌` | `❌` |
|   `is_audiobook`   |  `✔️`   | `❌` | `❌` |
|     `is_music`     |  `✔️`   | `❌` | `❌` |
| `is_notification`  |  `✔️`   | `❌` | `❌` |
|    `is_podcast`    |  `✔️`   | `❌` | `❌` |
|   `is_ringtone`    |  `✔️`   | `❌` | `❌` |

### AlbumModel

|   Methods    | Android | IOS  | Web  |
| :----------: | :-----: | :--: | :--: |
|     `id`     |  `✔️`   | `✔️` | `✔️` |
|   `album`    |  `✔️`   | `✔️` | `✔️` |
|  `albumId`   |  `✔️`   | `✔️` | `✔️` |
|   `artist`   |  `✔️`   | `✔️` | `✔️` |
|  `artistId`  |  `✔️`   | `✔️` | `✔️` |
| `numOfSongs` |  `✔️`   | `✔️` | `✔️` |

### PlaylistModel

|    Methods     | Android | IOS  | Web  |
| :------------: | :-----: | :--: | :--: |
|      `id`      |  `✔️`   | `✔️` | `❌` |
|   `playlist`   |  `✔️`   | `✔️` | `❌` |
|     `data`     |  `✔️`   | `❌` | `❌` |
|  `dateAdded`   |  `✔️`   | `✔️` | `❌` |
| `dateModified` |  `✔️`   | `✔️` | `❌` |
|  `numOfSongs`  |  `✔️`   | `✔️` | `❌` |
|   `artwork`    |  `❌`   | `✔️` | `❌` |

### ArtistModel

|     Methods      | Android | IOS  | Web  |
| :--------------: | :-----: | :--: | :--: |
|       `id`       |  `✔️`   | `✔️` | `✔️` |
|     `artist`     |  `✔️`   | `✔️` | `✔️` |
| `numberOfAlbums` |  `✔️`   | `✔️` | `✔️` |
| `numberOfTracks` |  `✔️`   | `✔️` | `✔️` |

### GenreModel

|   Methods    | Android | IOS  | Web  |
| :----------: | :-----: | :--: | :--: |
|     `id`     |  `✔️`   | `✔️` | `✔️` |
|   `genre`    |  `✔️`   | `✔️` | `✔️` |
| `numOfSongs` |  `✔️`   | `✔️` | `✔️` |

### DeviceModel

|  Methods  | Android | IOS  | Web  |
| :-------: | :-----: | :--: | :--: |
| `version` |  `✔️`   | `✔️` | `✔️` |
|  `type`   |  `✔️`   | `✔️` | `✔️` |
|  `model`  |  `✔️`   | `✔️` | `❌` |
