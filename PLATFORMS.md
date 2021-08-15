# on_audio_query - Platforms support

Here you'll see a extra information about every method/type etc..

## Topics:

* [Methods](#methods)
* [Sort Types](#sorttypes)
    * [SongSortType](#songsorttype)
    * [AlbumSortType](#albumsorttype)
    * [ArtistSortType](#artistsorttype)
    * [PlaylistSortType](#playlistsorttype)
    * [GenreSortType](#genresorttype)
* [Order Types](#ordertypes)
* [Uri Types](#uritypes)
* [Artwork Types](#artworktype)
* [Artwork Format Types](#artworkformat)
* [Audios From Types](#audiosfromtype)
* [With Filter Types](#withfilterstype)
    * [AudiosArgs](#audiosargs)
    * [AlbumsArgs](#albumsargs)
    * [PlaylistsArgs](#playlistsargs)
    * [ArtistsArgs](#artistsargs)
    * [GenresArgs](#genressargs)
* [Models](#models)
    * [SongModel](#songmodel)
    * [AlbumModel](#albummodel)
    * [PlaylistModel](#playlistmodel)
    * [ArtistModel](#artistmodel)
    * [GenreModel](#genremodel)
* [DeviceModel](#devicemodel)

✔️ -> Supported <br>
❌ -> Not Supported <br>
⭕ -> Supported Partially/Platform Limitation

## Methods

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

## SortTypes

### SongSortType

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `DEFAULT` | `✔️` | `✔️` | <br>
| `ARTIST` | `✔️` | `✔️` | <br>
| `ALBUM` | `✔️` | `✔️` | <br>
| `DURATION` | `✔️` | `✔️` | <br>
| `DATA_ADDED` | `✔️` | `✔️` | <br>
| `SIZE` | `✔️` | `✔️` | <br>
| `DISPLAY_NAME` | `✔️` | `✔️` | <br>

### AlbumSortType

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `DEFAULT` | `✔️` | `✔️` | <br>
| `ARTIST` | `✔️` | `✔️` | <br>
| `ALBUM` | `✔️` | `✔️` | <br>
| `NUM_OF_SONGS` | `✔️` | `✔️` | <br>

### ArtistSortType

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `DEFAULT` | `✔️` | `❌` | <br>
| `ARTIST_NAME` | `✔️` | `✔️` | <br>
| `ARTIST_KEY` | `✔️` | `❌` | <br>
| `NUM_OF_TRACKS` | `✔️` | `✔️` | <br>
| `NUM_OF_ALBUMS` | `✔️` | `✔️` | <br>

### PlaylistSortType

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `DEFAULT` | `✔️` | `❌` | <br>
| `DATA_ADDED` | `✔️` | `❌` | <br>
| `PLAYLIST_NAME` | `✔️` | `❌` | <br>

### GenreSortType

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `DEFAULT` | `✔️` | `✔️` | <br>

## OrderTypes

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `ASC` | `✔️` | `✔️` | <br>
| `DESC` | `✔️` | `✔️` | <br>

## UriTypes

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `EXTERNAL` | `✔️` | `❌` | <br>
| `INTERNAL` | `✔️` | `✔️` | <br>

## ArtworkTypes

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `AUDIO` | `✔️` | `✔️` | <br>
| `ALBUM` | `✔️` | `✔️` | <br>

## ArtworkFormat

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `JPEG` | `✔️` | `✔️` | <br>
| `PNG` | `✔️` | `✔️` | <br>

## AudiosFromType

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `ALBUM_NAME` | `✔️` | `✔️` | <br>
| `ALBUM_ID` | `✔️` | `✔️` | <br>
| `ARTIST_NAME` | `✔️` | `✔️` | <br>
| `ARTIST_ID` | `✔️` | `✔️` | <br>
| `GENRE_NAME` | `✔️` | `✔️` | <br>
| `GENRE_ID` | `✔️` | `✔️` | <br>
| `PLAYLIST` | `✔️` | `✔️` | <br>

## WithFiltersType

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `AUDIOS` | `✔️` | `✔️` | <br>
| `ALBUMS` | `✔️` | `✔️` | <br>
| `PLAYLISTS` | `✔️` | `✔️` | <br>
| `ARTISTS` | `✔️` | `✔️` | <br>
| `GENRES` | `✔️` | `✔️` | <br>

### AudiosArgs

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `TITLE` | `✔️` | `✔️` | <br>
| `DISPLAY_NAME` | `✔️` | `❌` | <br>
| `ALBUM` | `✔️` | `✔️` | <br>
| `ARTIST` | `✔️` | `✔️` | <br>

### AlbumsArgs

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `ALBUM_NAME` | `✔️` | `✔️` | <br>
| `ARTIST` | `✔️` | `✔️` | <br>

### PlaylistsArgs

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `PLAYLIST_NAME` | `✔️` | `✔️` | <br>

### ArtistsArgs

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `ARTIST_NAME` | `✔️` | `✔️` | <br>

### GenresArgs

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `GENRE_NAME` | `✔️` | `✔️` | <br>

## Models

### SongModel

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `id` | `✔️` | `✔️` | <br>
| `data` | `✔️` | `✔️` | <br>
| `uri` | `✔️` | `❌` | <br>
| `displayName` | `✔️` | `✔️` | <br>
| `displayNameWOExt` | `✔️` | `✔️` | <br>
| `size` | `✔️` | `✔️` | <br>
| `album` | `✔️` | `✔️` | <br>
| `albumId` | `✔️` | `✔️` | <br>
| `artist` | `✔️` | `✔️` | <br>
| `artistId` | `✔️` | `✔️` | <br>
| `bookmark` | `✔️` | `✔️` | <br>
| `composer` | `✔️` | `✔️` | <br>
| `dateAdded` | `✔️` | `✔️` | <br>
| `dateModified` | `✔️` | `❌` | <br>
| `duration` | `✔️` | `✔️` | <br>
| `title` | `✔️` | `✔️` | <br>
| `track` | `✔️` | `✔️` | <br>
| `fileExtension` | `✔️` | `✔️` | <br>

### AlbumModel

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `id` | `✔️` | `✔️` | <br>
| `albumName` | `✔️` | `✔️` | <br>
| `albumId` | `✔️` | `✔️` | <br>
| `artist` | `✔️` | `✔️` | <br>
| `artistId` | `✔️` | `✔️` | <br>
| `numOfSongs` | `✔️` | `✔️` | <br>
| `artwork` | `✔️` | `✔️` | <br>

### PlaylistModel

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `id` | `✔️` | `✔️` | <br>
| `playlistName` | `✔️` | `✔️` | <br>
| `data` | `✔️` | `❌` | <br>
| `dateAdded` | `✔️` | `✔️` | <br>
| `dateModified` | `✔️` | `✔️` | <br>
| `numOfSongs` | `✔️` | `✔️` | <br>
| `artwork` | `❌` | `✔️` | <br>

### ArtistModel

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `id` | `✔️` | `✔️` | <br>
| `artistName` | `✔️` | `✔️` | <br>
| `numberOfAlbums` | `✔️` | `✔️` | <br>
| `numberOfTracks` | `✔️` | `✔️` | <br>

### GenreModel

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `id` | `✔️` | `✔️` | <br>
| `genreName` | `✔️` | `✔️` | <br>

### DeviceModel

|  Methods  |   Android   |   IOS   |
|--------------|-----------------|-----------------|
| `version` | `✔️` | `✔️` | <br>
| `type` | `✔️` | `✔️` | <br>
| `model` | `✔️` | `✔️` | <br>



