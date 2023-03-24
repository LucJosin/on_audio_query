/*
=============
Author: Lucas Josino
Github: https://github.com/LucJosin
Website: https://www.lucasjosino.com/
=============
Plugin/Id: on_audio_query#0
Homepage: https://github.com/LucJosin/on_audio_query
Pub: https://pub.dev/packages/on_audio_query
License: https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/LICENSE
Copyright: © 2021, Lucas Josino. All rights reserved.
=============
*/

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(
    const MaterialApp(
      home: Songs(),
    ),
  );
}

class Songs extends StatefulWidget {
  const Songs({Key? key}) : super(key: key);

  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  // Main method.
  final OnAudioQuery _audioQuery = OnAudioQuery();

  // Indicates if application has permission to the library.
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    // (Optinal) Set logging level. By default will be set to 'WARN'.
    //
    // Log will appear on:
    //  * XCode: Debug Console
    //  * VsCode: Debug Console
    //  * Android Studio: Debug and Logcat Console
    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);

    // Check and request for permission.
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions() async {
    _hasPermission = await _audioQuery.checkAndRequest();

    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OnAudioQueryExample"),
        elevation: 2,
      ),
      body: Center(
        child: !_hasPermission
            ? const Text("Application doesn't have access to the library")
            : FutureBuilder<List<SongModel>>(
                // Default values:
                future: _audioQuery.querySongs(
                  sortType: null,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true,
                ),
                builder: (context, item) {
                  // Waiting content.
                  if (item.data == null) {
                    return const CircularProgressIndicator();
                  }

                  // 'Library' is empty.
                  if (item.data!.isEmpty) return const Text("Nothing found!");

                  // You can use [item.data!] direct or you can create a:
                  // List<SongModel> songs = item.data!;
                  return ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(item.data![index].title),
                        subtitle: Text(item.data![index].artist ?? "No Artist"),
                        trailing: const Icon(Icons.arrow_forward_rounded),
                        // This Widget will query/load image.
                        // You can use/create your own widget/method using [queryArtwork].
                        leading: QueryArtworkWidget(
                          controller: _audioQuery,
                          id: item.data![index].id,
                          type: ArtworkType.AUDIO,
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
