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
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../widgets/dialog_widget.dart';

class QueryAudios extends StatefulWidget {
  const QueryAudios({Key? key}) : super(key: key);

  @override
  _QueryAudiosState createState() => _QueryAudiosState();
}

class _QueryAudiosState extends State<QueryAudios> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QueryExample"),
        elevation: 0,
        actions: [
          // A 'Dialog' explaining about this 'constant' list.
          IconButton(
            onPressed: () => buildDialog(
              context,
              'Constant list',
              'The only way to \'update\' this list is calling: setState',
            ),
            icon: const Icon(Icons.info_outline),
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<List<AudioModel>>(
          // Default values:
          //
          // sortType: null,
          // orderType: OrderType.ASC_OR_SMALLER,
          // uriType: UriType.EXTERNAL,
          // ignoreCase: true,
          // toQuery: const {},
          // toRemove: const {},
          // type: const {AudioType.IS_MUSIC : true},
          future: _audioQuery.queryAudios(
            filter: MediaFilter.forAudios(
                // limit: 50,
                ),
          ),
          builder: (context, item) {
            // When you try 'query' without asking for [READ] permission the plugin
            // will throw a [PlatformException].
            //
            // This 'no permission' code exception is: 403.
            if (item.hasError) {
              // If the error is a [PlatformException] send the default message.
              if (item.error is PlatformException) {
                // Define error as PlatformException.
                var error = item.error as PlatformException;

                // Return this information or call [permissionsRequest] method.
                return Text(error.message!);
              } else {
                // Send the 'unknown' exception.
                return Text('${item.error}');
              }
            }

            // Waiting content.
            if (item.data == null) return const CircularProgressIndicator();

            // 'Library' is empty.
            if (item.data!.isEmpty) return const Text("Nothing found!");

            // You can use [item.data!] direct or you can create a:
            // List<SongModel> songs = item.data!;
            return ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (_, index) {
                // Normal list.
                return ListTile(
                  title: Text(item.data![index].title),
                  subtitle: Text(item.data![index].artist ?? '<Unknown>'),
                  // This Widget will query/load image. Just add the id and type.
                  // You can use/create your own widget/method using [queryArtwork].
                  leading: QueryArtworkWidget(
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                  ),
                  onTap: () => debugPrint('${item.data![index]}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
