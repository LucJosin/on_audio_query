import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ObserveSongs extends StatefulWidget {
  const ObserveSongs({Key? key}) : super(key: key);

  @override
  ObserveSongsState createState() => ObserveSongsState();
}

class ObserveSongsState extends State<ObserveSongs> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ObserveExample"),
        elevation: 0,
      ),
      body: Center(
        child: StreamBuilder<List<SongModel>>(
          // Default values:
          stream: _audioQuery.observeSongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
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
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(item.data![index].title),
                  subtitle: Text(item.data![index].artist ?? "No Artist"),
                  trailing: const Icon(Icons.arrow_forward_rounded),
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
