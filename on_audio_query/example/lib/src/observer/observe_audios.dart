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

class ObserveAudios extends StatefulWidget {
  const ObserveAudios({Key? key}) : super(key: key);

  @override
  ObserveAudiosState createState() => ObserveAudiosState();
}

class ObserveAudiosState extends State<ObserveAudios> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ObserveExample"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sensors_rounded),
            onPressed: () async {
              // The [observersStatus] will return information about every observer.
              // Will return [true] if the observers is running and [false] if not (or it's null).
              ObserversModel r = await _audioQuery.observersStatus();
              debugPrint("$r");
            },
          ),
          // A 'Dialog' explaining about this 'dynamic' list.
          IconButton(
            onPressed: () => buildDialog(
              context,
              'Dynamic list',
              'Every change will be notified and will automatically update the UI',
            ),
            icon: const Icon(Icons.info_outline),
          )
        ],
      ),
      body: Center(
        // In this case we'll use the [StreamBuilder] widget.
        // This widget will automatically [listen] and [dispose] the observer
        // when the state(page) is closed.
        //
        // If you are using another method. Remember to 'cancel' the listener before
        // close the application or the page.
        child: StreamBuilder<List<AudioModel>>(
          // Default values:
          //
          // sortType: null,
          // orderType: OrderType.ASC_OR_SMALLER,
          // uriType: UriType.EXTERNAL,
          // ignoreCase: true,
          // toQuery: const {},
          // toRemove: const {},
          // type: const {AudioType.IS_MUSIC : true},
          stream: _audioQuery.observeAudios(
            filter: MediaFilter.forAudios(
              limit: 50, // Debug
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
                  subtitle: Text(item.data![index].artist ?? "No Artist"),
                  // This Widget will query/load image. Just add the id and type.
                  // You can use/create your own widget/method using [queryArtwork].
                  leading: QueryArtworkWidget(
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                    keepOldArtwork: true,
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
