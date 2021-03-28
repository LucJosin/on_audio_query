/*
Author: Lucas Josino
Github: https://github.com/LucasPJS
Plugin: on_audio_query
Homepage: https://github.com/LucasPJS/on_audio_query
Copyright: © 2021, Lucas Josino. All rights reserved.
License: https://github.com/LucasPJS/on_audio_query/blob/main/LICENSE
*/

import 'dart:io';

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
  List<SongModel> songList = [];
  int? version;

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  getVersion() async {
    version = await OnAudioQuery().getDeviceSDK();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Songs"),
          elevation: 2,
        ),
        body: FutureBuilder(
          future: OnAudioQuery()
              .querySongs(SongSortType.DEFAULT, OrderType.ASC_OR_SMALLER, true),
          builder: (context, AsyncSnapshot<List<SongModel>> item) {
            if (item.data != null) {
              songList = item.data!;
              return ListView.builder(
                itemCount: songList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(songList[index].title),
                    subtitle: Text(songList[index].artist),
                    trailing: Icon(Icons.arrow_forward_rounded),
                    leading: version! >= 29
                        ? QueryArtworkWidget(
                            id: songList[index].id,
                            type: ArtworkType.AUDIO,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image(
                              image: FileImage(
                                File(songList[index].artwork!),
                              ),
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
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
