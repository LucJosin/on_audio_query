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
          //
          // sortType: null,
          // orderType: OrderType.ASC_OR_SMALLER,
          // uriType: UriType.EXTERNAL,
          // ignoreCase: true,
          stream: _audioQuery.observeSongs(
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
                // A 'Dialog' explaining about this 'dynamic' list.
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
                        "Dynamic list. \nEvery change will be notified and will automatically update the UI",
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
