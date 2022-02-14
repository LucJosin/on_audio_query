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
        child: FutureBuilder<List<SongModel>>(
          // Default values:
          //
          // sortType: null,
          // orderType: OrderType.ASC_OR_SMALLER,
          // uriType: UriType.EXTERNAL,
          // ignoreCase: true,
          future: _audioQuery.querySongs(
            sortType: SongSortType.DATE_ADDED,
            orderType: OrderType.DESC_OR_GREATER,
          ),
          builder: (context, item) {
            // Loading content
            if (item.data == null) return const CircularProgressIndicator();

            // When you try "query" without asking for [READ] or [Library] permission
            // the plugin will return a [Empty] list.
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
