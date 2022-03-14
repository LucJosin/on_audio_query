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

class QuerySongs extends StatefulWidget {
  const QuerySongs({Key? key}) : super(key: key);

  @override
  _QuerySongsState createState() => _QuerySongsState();
}

class _QuerySongsState extends State<QuerySongs> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QueryExample"),
        elevation: 0,
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
          future: _audioQuery.querySongs(
            filter: MediaFilter.forSongs(),
          ),
          builder: (context, item) {
            // When you try 'query' without asking for [READ] permission the plugin
            // will throw a [PlatformException].
            //
            // This 'no permission' code exception is: 403.
            if (item.hasError) {
              // Define error as PlatformException.
              var error = item.error as PlatformException;

              // If the exception code is [403] the app doesn't have permission to
              // [READ].
              String message = error.code == "403" ? error.message! : "$error";

              // Return this information or call [permissionsRequest] method.
              return Text(message);
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
                // A 'Dialog' explaining about this 'static' list.
                if (index == 0) {
                  return Container(
                    height: 100,
                    width: double.infinity,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      border: Border.all(
                        color: Theme.of(context).hintColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Static list. \nThe only way to 'update' this list is calling: setState",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                // Normal list.
                return ListTile(
                  title: Text(item.data![index].title),
                  subtitle: Text(item.data![index].artist ?? "No Artist"),
                  // This Widget will query/load image. Just add the id and type.
                  // You can use/create your own widget/method using [queryArtwork].
                  leading: QueryArtworkWidget(
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
