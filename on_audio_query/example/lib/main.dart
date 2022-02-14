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
import 'package:on_audio_query_example/src/observer/observe_songs.dart';
import 'package:on_audio_query_example/src/query/query_songs.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const Main(),
    ),
  );
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    // Request to the user, the permissoion to read MediaStore(Android) and
    // MPMediaLibrary(IOS).
    requestPermission();
  }

  requestPermission() async {
    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        bool r = await _audioQuery.permissionsRequest();
        debugPrint("$r");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("OnAudioQueryExample"),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Select one option:"),
            // This option will open a 'static' page.
            //
            // The only way to show new/deleted items is calling 'setState'.
            //
            // - Uses the 'FutureBuilder' widget.
            // - Will never update the UI automatically.
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const QuerySongs(),
                ),
              ),
              child: Container(
                height: 200,
                width: 200,
                color: Theme.of(context).backgroundColor,
                child: const Center(
                  child: Text("Static"),
                ),
              ),
            ),
            // This option will open a 'dynamic' page.
            //
            // Everytime something change, e.g: add or remove songs, will 'trigger'
            // a listener and update the UI
            //
            // - Uses the 'StreamBuilder' widget.
            // - Update the UI automatically.
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ObserveSongs(),
                ),
              ),
              child: Container(
                height: 200,
                width: 200,
                color: Theme.of(context).backgroundColor,
                child: const Center(
                  child: Text("Dynamic"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
