# on_audio_query

`on_audio_query` é um [Flutter](https://flutter.dev/) Plugin usado para adquirir informações de áudios/músicas [título, artista, album, etc..] do celular. <br>

## Ajuda:

**Algum problema? [Issues](https://github.com/LucasPJS/on_audio_query/issues)** <br>
**Alguma sugestão? [Pull request](https://github.com/LucasPJS/on_audio_query/pulls)**

### Traduções:

NOTE: Fique à vontade para ajudar nas traduções

* [Inglês](README.md)
* [Português](README.pt-BR.md)

## Tópicos:

* [Exemplos em Gif](#exemplos-em-gif)
* [Como instalar](#como-instalar)
* [Como usar](#como-usar)
* [Exemplos](#exemplos)
* [Licença](#licença)

## Exemplos em Gif:
| <img src="https://user-images.githubusercontent.com/76869974/112378123-522c1a00-8cc5-11eb-880d-ba67706c415d.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/112378181-62dc9000-8cc5-11eb-8cb3-c8db71372fa9.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/112378214-6e2fbb80-8cc5-11eb-996a-d61bb8a620ca.gif"/> | <img src="https://user-images.githubusercontent.com/76869974/112378250-7687f680-8cc5-11eb-94a1-ea91868d119c.gif"/> |
|:---:|:---:|:---:|:---:|
| Músicas | Albums | Playlists | Artistas |

## Como instalar:
Adicione o seguinte codigo para seu `pubspec.yaml`:
```yaml
dependencies:
  on_audio_query: ^1.0.0
```

#### Solicitar Permissões:
Se você quer usar a solicitação de permissões interna, irá precisar adicionar os seguintes codigos para seu `AndroidManifest.xml`
```xml
<manifest> ...

  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

</manifest>
```

## Algumas qualidades:

* Opcional e Interna solicitação de permissão para `LER` e `ESCREVER`.
* Pega todos os áudios e áudios classificados como `is_music`.
* Pega todos os albums e áudios específicos dos albums.
* Pega todos os artistas e áudios específicos dos artistas.
* Pega todas as playlists e áudios específicos das playlists.
* Pega todos os gêneros e áudios específicos dos gêneros.
* Criar/Deletar/Renomear playlists.
* Adicionar/Remover/Mover específicos áudios para playlists.
* Específicos tipos de classificação para todos os métodos.

## Para fazer:

* Adicionar uma melhor performace para todo o plugin.
* Adicionar método para editar tag dos audios.
* Criar métodos para IOS.
* Opção para remover músicas.
* Arrumar erros.

## Como usar:

```dart
OnAudioQuery() // O comando principal para usar o plugin.
```
Todos os tipos de métodos nesse plugin:

|  Métodos  |   Parâmetros   |   Return   |
|--------------|-----------------|-----------------|
| [`querySongs`](#querysongs) | `(SortType, OrderType, RequestPermission)` | `List<SongModel>` | <br>
| [`queryAudio`]() | `(SortType, OrderType, RequestPermission)`. | `List<SongModel>` | <br>
| [`queryAlbums`](#queryalbums) | `(SortType, OrderType, RequestPermission)` | `List<AlbumModel>` | <br>
| [`queryArtists`](#queryartists) | `(SortType, OrderType, RequestPermission)` | `List<ArtistModel>` | <br>
| [`queryPlaylists`](#queryplaylists) | `(SortType, OrderType, RequestPermission)` | `List<PlaylistModel>` | <br>
| [`queryGenres`](#querygenres) | `(SortType, OrderType, RequestPermission)` | `List<GenreModel>` | <br>
| [`queryAudiosFrom`]() | `(Type, Where, RequestPermission)` | `List<SongModel>` | <br>
| [`queryArtworks`]() | `(Id, Type, Format, Size, RequestPermission)` | `Uint8List` | <br>
| [`createPlaylist`]() | `(PlaylistName, RequestPermission)` | `bool` | <br>
| [`removePlaylist`]() | `(PlaylistId, RequestPermission)` | `bool` | <br>
| [`addToPlaylist`]() | **[NT]**`(PlaylistId, AudioId, RequestPermission)` | `bool` | <br>
| [`removeFromPlaylist`]() | **[NT]**`(PlaylistId, AudioId, RequestPermission)` | `bool` | <br>
| [`audiosFromPlaylist`]() | **[NT]**`(PlaylistId, RequestPermission)` | `List<SongModel>` | <br>
| [`renamePlaylist`]() | `(PlaylistId, NewName, RequestPermission)` | `bool` | <br>
| [`moveItemTo`]() | **[NT]**`(PlaylistId, From, To, RequestPermission)` | `bool` | <br>
| [`permissionsRequest`]() | `(retryRequest)` | `bool` | <br>
| [`permissionsStatus`]() |  | `bool` | <br>
| [`getDeviceSDK`]() |  | `int` | <br>
| [`getDeviceRelease`]() |  | `String` | <br>
| [`getDeviceCode`]() |  | `String` | <br>

**Note: Albuns dos métodos para adquirir exigem o `SortType` e `RequestPermisson`, por padrão, irão ser setados como `DEFAULT` and `false`**

**Veja todos os tipos de classificação em [Exemplos](#exemplos)**

**[NT]** -> Precisa de testes

## Exemplos:

#### querySongs
```dart
  someName() async {
    //DEFAULT: SongSortType.TITLE, OrderType.ASC_OR_SMALLER and false
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

#### queryArtworks
**Note: Only in Android >= Q/10**
```dart
  someName() async {
    //DEFAULT: ArtworkFormat.JPEG, 200 and false
    var something = await OnAudioQuery().queryArtworks(SongId, ArtworkType.AUDIO ...)
  }

  //Ou você pode usar um Widget básico e customizável
  Widget someOtherName() async {
    var version = await OnAudioQuery().getDeviceSDK();
    if (version >= 29) {
      return QueryArtworkWidget(
        id: SongId, 
        type: ArtworkType.AUDIO
      );
    }
    return Icon(Icons.image_not_supported)
  }
```

## LICENÇA:

* [LICENSE](https://github.com/LucasPJS/on_audio_query/blob/main/LICENSE)

> * [Voltar ao Topo](#on_audio_query)
