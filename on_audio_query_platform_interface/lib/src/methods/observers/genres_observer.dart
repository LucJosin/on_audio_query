import 'dart:async';
import 'dart:io';

import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import '/src/methods/helpers/query_helper_io.dart';
import '/src/methods/queries/genres_query.dart';

///
class GenresObserver implements ObserverInterface {
  // Filter
  MediaFilter _filter = MediaFilter.forGenres();

  // Queries
  final GenresQuery _genresQuery = GenresQuery();

  // Stream controller.
  StreamController<List<GenreModel>>? _controller;

  // Directory watcher.
  StreamSubscription<FileSystemEvent>? _toWatchStream;

  // Internal variable to detect when the observer is running or not.
  bool _isRunning = false;

  @override
  Stream<List<GenreModel>> get stream {
    // If [isRunning] is false or the method [startObserver] was never called
    // throw a [NullThrownError].
    if (!_isRunning || _controller == null) {
      throw NullThrownError();
    }

    //
    return _controller!.stream;
  }

  @override
  bool get isRunning => _isRunning;

  @override
  Future<void> startObserver([Map<String, dynamic>? args]) async {
    // If null, Initialize the [_controller].
    _controller ??= StreamController<List<GenreModel>>.broadcast(
      onListen: onChange,
      onCancel: stopObserver,
    );

    // Define if we need listen all 'sub-folders'.
    bool followDir = args?["followDir"] ?? true;

    // Define the filter.
    _filter = args?["filter"] ?? _filter;

    // If [isRunning] is false, setup the listener.
    if (!_isRunning) {
      // Define the directory to listen to. If [path] is null we'll use the
      // [defaultMusicPath] E.g: (C:\Users\user\Music)
      Directory dirToWatch = Directory(QueryHelper.defaultMusicPath);

      // Check if this path exists.
      if (!await dirToWatch.exists()) {
        // If null, throw a error.
        _controller?.addError(NullThrownError());

        // After the error, stop the observer.
        stopObserver();
      }

      // Start watching the folder.
      _toWatchStream = dirToWatch.watch(recursive: followDir).listen(
            (_) => onChange(),
            onError: (error) => _controller!.addError(error),
            cancelOnError: false,
          );

      // 'Init' the observer 'externally'
      _isRunning = true;
    }

    // Send the first(if isRunning is false) result or Send a result if it's
    // already running.
    _controller!.add(
      await _genresQuery.queryGenres(filter: _filter),
    );
  }

  @override
  void onChange() async {
    // Check if controller is null.
    if (_controller == null) return stopObserver();

    // Check if the controller is closed.
    if (_controller!.isClosed) return stopObserver();

    // Check if the controller is paused. If true, just ignore(or wait).
    if (_controller!.isPaused) return;

    // If the controller isn't null, closed or paused, send the new result.
    _controller!.add(
      await _genresQuery.queryGenres(filter: _filter),
    );
  }

  @override
  void stopObserver() async {
    // 'Close' the observer 'externally'
    _isRunning = false;

    // Close and cancel the controller and stream.
    await _controller?.close();
    await _toWatchStream?.cancel();

    //
    _controller = null;
    _toWatchStream = null;
  }
}
