import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

void main() {
  runApp(
    MaterialApp(
      home: Songs(),
    ),
  );
}

class Songs extends StatefulWidget {
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  List<SongModel> songList = [];
  SongSortType sortType = SongSortType.DEFAULT;
  OrderType orderType = OrderType.ASC_OR_SMALLER;
  bool orderBool = true;
  late DeviceModel deviceModel;

  @override
  void initState() {
    super.initState();
    getDevice();
  }

  getDevice() async => deviceModel = await OnAudioQuery().queryDeviceInfo();

  songInfo(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(20),
          title: Center(child: Text("Song Info")),
          content: Container(
            height: 490,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(songList[index].title),
                SizedBox(height: 25),
                SizedBox(width: 180, child: Text(songList[index].displayName)),
                SizedBox(height: 25),
                SizedBox(width: 180, child: Text(songList[index].data)),
                SizedBox(height: 25),
                Text(songList[index].artist ?? "No Artist"),
                SizedBox(height: 25),
                Text(songList[index].id.toString()),
                SizedBox(height: 25),
                Text(songList[index].duration.toString()),
                SizedBox(height: 25),
                Text(songList[index].size.toString()),
                SizedBox(height: 25),
                Text(songList[index].dateAdded.toString()),
              ],
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            )
          ],
        );
      },
    );
  }

  externalSetState() {
    setState(() {});
  }

  songSort() {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Sort Type"),
              content: Container(
                height: 380,
                child: Column(
                  children: [
                    RadioListTile(
                      title: Text("Default"),
                      value: SongSortType.DEFAULT,
                      groupValue: sortType,
                      onChanged: (SongSortType? value) {
                        setState(() {
                          sortType = value!;
                        });
                      },
                    ),
                    SizedBox(height: 6),
                    RadioListTile(
                      title: Text("Artist"),
                      value: SongSortType.ARTIST,
                      groupValue: sortType,
                      onChanged: (SongSortType? value) {
                        setState(() {
                          sortType = value!;
                        });
                      },
                    ),
                    SizedBox(height: 6),
                    RadioListTile(
                      title: Text("Album"),
                      value: SongSortType.ALBUM,
                      groupValue: sortType,
                      onChanged: (SongSortType? value) {
                        setState(() {
                          sortType = value!;
                        });
                      },
                    ),
                    SizedBox(height: 6),
                    RadioListTile(
                      title: Text("Date Added"),
                      value: SongSortType.DATA_ADDED,
                      groupValue: sortType,
                      onChanged: (SongSortType? value) {
                        setState(() {
                          sortType = value!;
                        });
                      },
                    ),
                    SizedBox(height: 6),
                    RadioListTile(
                      title: Text("Size"),
                      value: SongSortType.SIZE,
                      groupValue: sortType,
                      onChanged: (SongSortType? value) {
                        setState(() {
                          sortType = value!;
                        });
                      },
                    ),
                    SizedBox(height: 6),
                    CheckboxListTile(
                      title: Text("Alphabetical?"),
                      value: orderBool,
                      onChanged: (newValue) {
                        setState(() {
                          orderBool = newValue!;
                          orderType = orderType == OrderType.DESC_OR_GREATER
                              ? OrderType.ASC_OR_SMALLER
                              : OrderType.DESC_OR_GREATER;
                        });
                      },
                    )
                  ],
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    externalSetState();
                    Navigator.of(context).pop();
                  },
                  child: Text("Add"),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Songs"),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.update_rounded),
            onPressed: () {
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.sort_by_alpha_rounded),
            onPressed: () {
              songSort();
            },
          )
        ],
      ),
      body: FutureBuilder(
        future:
            OnAudioQuery().querySongs(sortType: sortType, orderType: orderType),
        builder: (context, AsyncSnapshot<List<SongModel>> item) {
          if (item.data != null) {
            songList = item.data!;
            return ListView.builder(
              itemCount: songList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => songInfo(context, index),
                  title: Text(songList[index].title),
                  subtitle: Text(songList[index].artist ?? "No Artist"),
                  trailing: Icon(Icons.arrow_forward_rounded),
                  leading: QueryArtworkWidget(
                    id: songList[index].id,
                    type: ArtworkType.AUDIO,
                  ),
                  onLongPress: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Playlists(
                          audioId: songList[index].id,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class Playlists extends StatefulWidget {
  final int audioId;
  const Playlists({Key? key, required this.audioId}) : super(key: key);

  @override
  _PlaylistsState createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder<List<PlaylistModel>>(
          future: OnAudioQuery().queryPlaylists(),
          builder: (context, item) {
            if (item.data == null) return CircularProgressIndicator();

            if (item.data!.isEmpty) return Text("No data found");

            return ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(item.data![index].playlist),
                  subtitle: Text(item.data![index].id.toString()),
                  onTap: () async {
                    var result = await OnAudioQuery().addToPlaylist(
                      item.data![index].id,
                      widget.audioId,
                    );
                    Navigator.of(context).pop([result]);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PlaylistItems extends StatefulWidget {
  final int playlistId;
  const PlaylistItems({Key? key, required this.playlistId}) : super(key: key);

  @override
  _PlaylistItemsState createState() => _PlaylistItemsState();
}

class _PlaylistItemsState extends State<PlaylistItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder<List<SongModel>>(
          future: OnAudioQuery()
              .queryAudiosFrom(AudiosFromType.PLAYLIST, widget.playlistId),
          builder: (context, item) {
            if (item.data == null) return CircularProgressIndicator();

            if (item.data!.isEmpty) return Text("No data found");

            return ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(item.data![index].title),
                  subtitle: Text(item.data![index].artist ?? "No Artist"),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
