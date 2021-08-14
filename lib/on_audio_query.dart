/*
=============
Author: Lucas Josino
Github: https://github.com/LucasPJS
Website: https://lucasjosino.com/
=============
Plugin/Id: on_audio_query#0
Homepage: https://github.com/LucasPJS/on_audio_query
Pub: https://pub.dev/packages/on_audio_query
License: https://github.com/LucasPJS/on_audio_query/blob/main/LICENSE
Copyright: © 2021, Lucas Josino. All rights reserved.
=============
*/

library on_audio_query;

//
import 'dart:async';
import 'dart:typed_data';

//Dart/Flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

//Controller
part 'details/on_audio_query_controller.dart';

//Extensions
part 'details/extensions/models_extensions.dart';

//Models
part 'details/models/song_model.dart';
part 'details/models/album_model.dart';
part 'details/models/artist_model.dart';
part 'details/models/playlist_model.dart';
part 'details/models/genre_model.dart';
//
part 'details/models/device_model.dart';

//Sort Types
part 'details/types/sort_types/song_sort_type.dart';
part 'details/types/sort_types/album_sort_type.dart';
part 'details/types/sort_types/artist_sort_type.dart';
part 'details/types/sort_types/playlist_sort_type.dart';
part 'details/types/sort_types/genre_sort_type.dart';
//
part 'details/types/order_type.dart';
part 'details/types/artwork_type.dart';
part 'details/types/audios_from_type.dart';
part 'details/types/audios_only_type.dart';
part 'details/types/with_filters_type.dart';
part 'details/types/uri_type.dart';
part 'details/types/songs_by_type.dart';
//

//Widget
part 'widget/queryArtworkWidget.dart';
