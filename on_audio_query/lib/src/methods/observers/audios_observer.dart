import 'dart:async';
import 'dart:io';

import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import '../helpers/query_helper_io.dart';
import '/src/methods/queries/audios_query.dart';

class AudiosObserver implements ObserverInterface {
  // Helper
  final QueryHelper _helper = QueryHelper();

  // Query
  late AudiosQuery _query;

  //
  StreamController<List<AudioModel>>? _controller;

  //
  StreamSubscription<FileSystemEvent>? _toWatchStream;

  // [Internal] variable to detect when the observer is running or not.
  bool _isRunning = false;

  @override
  Stream<List<AudioModel>> get stream {
    //
    if (_controller == null) throw NullThrownError();

    //
    return _controller!.stream;
  }

  @override
  bool get isRunning => _isRunning;

  @override
  Future<Stream<List<AudioModel>>> startObserver([
    Map<String, dynamic>? args,
  ]) async {
    //
    _controller ??= StreamController<List<AudioModel>>.broadcast(
      onListen: onChange,
      onCancel: stopObserver,
    );

    //
    bool followDir = args?["followDir"] ?? true;

    //
    String? path = args?["path"];

    //
    if (!_isRunning) {
      //
      _query = args?['query'] ?? AudiosQuery();

      //
      Directory dirToWatch;

      //
      dirToWatch = Directory(path ?? _helper.defaultMusicPath);

      //
      if (!await dirToWatch.exists()) {
        //
        _controller?.addError(NullThrownError());

        //
        stopObserver();
      }

      //
      Stream<FileSystemEvent> toWatch = dirToWatch.watch(recursive: followDir);

      //
      _toWatchStream = toWatch.listen(
        (_) => onChange(),
        onError: (error) => _controller!.addError(error),
        cancelOnError: false,
      );

      //
      _isRunning = true;
    }

    //
    _controller?.add(await _query.queryAudios());

    return _controller!.stream;
  }

  @override
  void onChange() async {
    //
    if (_controller == null) {
      stopObserver();
      return;
    }

    //
    if (_controller!.isClosed) {
      stopObserver();
      return;
    }

    //
    if (_controller!.isPaused) return;

    //
    _controller!.add(await _query.queryAudios());
  }

  @override
  void stopObserver() async {
    //
    _isRunning = false;

    //
    await _controller?.close();
    await _toWatchStream?.cancel();

    //
    _controller = null;
    _toWatchStream = null;
  }
}
