# on_audio_query
[![Pub.dev](https://img.shields.io/pub/v/on_audio_query?color=9cf&label=Pub.dev&style=flat-square)](https://pub.dev/packages/on_audio_query)
[![Platforms](https://img.shields.io/badge/Platform-Android%20%7C%20IOS-9cf?&style=flat-square)]()
[![Languages](https://img.shields.io/badge/Language-Flutter%20%7C%20Kotlin%20%7C%20Swift-9cf?&style=flat-square)]()

`on_audio_query` é um [Flutter](https://flutter.dev/) Plugin usado para adquirir informações de áudios/músicas 🎶 [título, artista, album, etc..] do celular. <br>

## Ajuda:

**Algum problema? [Issues](https://github.com/LucasPJS/on_audio_query/issues)** <br>
**Alguma sugestão? [Pull request](https://github.com/LucasPJS/on_audio_query/pulls)**

### Extensões:

<!-- * [on_audio_edit](https://github.com/LucasPJS/on_audio_edit) - Usado para editar audio metadata. -->
* [on_audio_room](https://github.com/LucasPJS/on_audio_room) - Usado para guardar audio [Favoritos, Mais tocados, etc..].

### Traduções:

NOTE: Fique à vontade para ajudar nas traduções

* [Inglês](README.md)
* [Português](README.pt-BR.md)

## Tópicos:

* [Exemplos em Gif](#exemplos-em-gif)
* [Como instalar](#como-instalar)
* [Plataformas](#platformas)
* [Como usar](#como-usar)
* [Exemplos](#exemplos)
* [Licença](#licença)

## Exemplos em Gif:
| <img src="https://user-images.githubusercontent.com/76869974/112378123-522c1a00-8cc5-11eb-880d-ba67706c415d.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/112378181-62dc9000-8cc5-11eb-8cb3-c8db71372fa9.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/112378214-6e2fbb80-8cc5-11eb-996a-d61bb8a620ca.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/112378250-7687f680-8cc5-11eb-94a1-ea91868d119c.gif"/> |
|:---:|:---:|:---:|:---:|
| Músicas | Albums | Playlists | Artistas |

## Platformas:

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

✔️ -> Tem suporte <br>
❌ -> Não tem suporte <br>
⭕ -> Suporte limitado/Limitação da platforma

**[Veja todos os suportes](./PLATFORMS.md)**

## Como instalar:
Adicione o seguinte codigo para seu `pubspec.yaml`:
```yaml
dependencies:
  on_audio_query: ^2.0.0-beta.3
```

#### Solicitar Permissões:
#### Android:
Para usar esse plugin adicione o seguinte código no seu `AndroidManifest.xml`
```xml
<manifest> ...

  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

</manifest>
```

#### IOS:
Para usar esse plugin adicione o seguinte código no seu `Info.plist`
```plist
	<key>NSAppleMusicUsageDescription</key>
	<string>..Adicione um motivo..</string>
```

## Algumas qualidades:

* Opcional e Interna solicitação de permissão para `LER` e `ESCREVER`.
* Pega todos os áudios.
* Pega todos os albums e áudios específicos dos albums.
* Pega todos os artistas e áudios específicos dos artistas.
* Pega todas as playlists e áudios específicos das playlists.
* Pega todos os gêneros e áudios específicos dos gêneros.
* Pega todos os métodos de query com `keys` específicas [Search/Busca].
* Pega todos as pastas e áudios específicos das pastas.
* Criar/Deletar/Renomear playlists.
* Adicionar/Remover/Mover específicos áudios para playlists.
* Específicos tipos de classificação para todos os métodos.

## Para fazer:

* Adicionar uma melhor performace para todo o plugin.
* Adicionar suporte para Web/Windows/MacOs/Linux.
* Opção para remover músicas.
* Arrumar erros.

## Como usar:

```dart
OnAudioQuery() // O comando principal para usar o plugin.
```
Todos os tipos de métodos nesse plugin:

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

**See more: <a href="https://pub.dev/documentation/on_audio_query/latest/on_audio_query/QueryArtworkWidget-class.html" target="_blank">QueryArtworkWidget</a>**

### Abreviações

**[NT]** -> Precisa de testes <br>
**[BG]** -> Bug no Android 10/Q

## Exemplos:

#### querySongs
```dart
  someName() async {
    //DEFAULT: SongSortType.TITLE, OrderType.ASC_OR_SMALLER, UriType.EXTERNAL and false
    var something = await OnAudioQuery().querySongs()
  }
```

#### queryAlbums
```dart
  someName() async {
    //DEFAULT: AlbumSortType.ALBUM, OrderType.ASC_OR_SMALLER and false
    var something = await OnAudioQuery().queryAlbums()
  }
```

#### queryArtists
```dart
  someName() async {
    //DEFAULT: ArtistSortType.ARTIST, OrderType.ASC_OR_SMALLER and false
    var something = await OnAudioQuery().queryArtists() 
  }
```

#### queryPlaylists
```dart
  someName() async {
    //DEFAULT: PlaylistSortType.NAME, OrderType.ASC_OR_SMALLER and false
    var something = await OnAudioQuery().queryPlaylists()
  }
```

#### queryGenres
```dart
  someName() async {
    //DEFAULT: GenreSortType.NAME, OrderType.ASC_OR_SMALLER and false
    var something = await OnAudioQuery().queryGenres()
  }
```

#### queryArtwork
⚠ **Note: Apenas em Android >= Q/10**
```dart
  someName() async {
    //DEFAULT: ArtworkFormat.JPEG, 200 and false
    var something = await OnAudioQuery().queryArtwork(SongId, ArtworkType.AUDIO ...)
  }
```

Ou você pode usar um Widget básico e customizável.
**Veja o exemplo [QueryArtworkWidget](#queryartworkwidget)**

#### queryWithFilters
```dart
  someName() async {
    // DEFAULT: Args.TITLE and false
    // ArgsTypes: AudiosArgs, AlbumsArgs, PlaylistsArgs, ArtistsArgs, GenresArgs
    List<dynamic> something = await OnAudioQuery().queryWithFilters(
        "Sam Smith", 
        WithFiltersType.ARTISTS,
      );

    // Depois de receber o resultado do [queryWithFilters], converta a lista usando:
    List<TypeModel> convertedList = something.toTypeModel();

    // Example:
    List<SongModel> convertedSongs = something.toArtistModel(); 
  }
```

**Veja mais em [QueryArtworkWidget](https://pub.dev/documentation/on_audio_query/latest/on_audio_query/QueryArtworkWidget-class.html)**

## LICENÇA:

* [LICENSE](https://github.com/LucasPJS/on_audio_query/blob/main/LICENSE)

> * [Voltar ao Topo](#on_audio_query)
