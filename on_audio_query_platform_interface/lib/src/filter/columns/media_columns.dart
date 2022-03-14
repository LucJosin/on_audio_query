// ignore_for_file: non_constant_identifier_names

import '../../controllers/columns_controller.dart';

///
abstract class MediaColumns {
  ///
  static AudioColumns get Audio => AudioColumns();

  ///
  static AlbumColumns get Album => AlbumColumns();

  ///
  static ArtistColumns get Artist => ArtistColumns();

  ///
  static PlaylistColumns get Playlist => PlaylistColumns();

  ///
  static GenreColumns get Genre => GenreColumns();
}
