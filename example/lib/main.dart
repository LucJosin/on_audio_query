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

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

void main() {
  runApp(Songs());
}

class Songs extends StatefulWidget {
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  late List<SongModel> songList;
  late DeviceModel deviceModel;

  @override
  void initState() {
    super.initState();
    getDevice();
  }

  getDevice() async => deviceModel = await OnAudioQuery().queryDeviceInfo();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("OnAudioQueryExample"),
          elevation: 2,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: FutureBuilder<List<SongModel>>(
          future: OnAudioQuery().querySongs(
            SongSortType.DEFAULT,
            OrderType.ASC_OR_SMALLER,
            UriType.EXTERNAL,
            false,
          ),
          builder: (context, item) {
            if (item.data != null) {
              songList = item.data!;
              return ListView.builder(
                itemCount: songList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(songList[index].title),
                    subtitle: Text(songList[index].artist),
                    trailing: Icon(Icons.arrow_forward_rounded),
                    leading: QueryArtworkWidget(
                      id: songList[index].id,
                      type: ArtworkType.AUDIO,
                      artwork: songList[index].artwork,
                      deviceSDK: deviceModel.sdk,
                    ),
                  );
                },
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
