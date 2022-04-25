///
abstract class ObserverInterface {
  /// [Get] variable to detect when the observer is running or not.
  bool get isRunning;

  ///
  Stream<dynamic> get stream;

  ///
  void startObserver(Map<String, dynamic> args) {}

  ///
  void onChange() {}

  ///
  void onError(dynamic error) {}

  ///
  void stopObserver() {}
}
