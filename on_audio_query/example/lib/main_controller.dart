import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:url_launcher/url_launcher.dart';

class MainController {
  ///
  final OnAudioQuery query = OnAudioQuery();

  ///
  bool get hasPermission => _hasPermission;

  ///
  bool get hasError => _hasError;

  ///
  bool _hasPermission = false;

  ///
  bool _hasError = false;

  ///
  void checkPermisison() async {
    // Check if the plugin has permission to read the library.
    try {
      _hasPermission = await query.permissionsStatus();

      // If [permissionsStatus] is called from [Web] or [Desktop] platforms,
      // will throw a [UnimplementedError]. So, we'll use this to disable
      // the grant buttton.
    } on UnimplementedError {
      _hasError = true;

      // Some went wrong.
    } catch (e) {
      _hasPermission = false;
    }
  }

  ///
  Function() requestPermission(BuildContext context) {
    return () async {
      bool r = hasPermission ? hasPermission : await query.permissionsRequest();

      SnackBar snackBar = SnackBar(
        content: Row(
          children: [
            Icon(
              r ? Icons.done : Icons.error_outline_rounded,
            ),
            const SizedBox(
              width: 18,
            ),
            Text(
              r
                  ? 'The plugin has permission!'
                  : 'The plugin has no permission!',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: r ? Colors.green : Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    };
  }

  void launchLink(Uri url, BuildContext context) async {
    if (!await launchUrl(url)) {
      SnackBar snackBar = SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded),
            const SizedBox(
              width: 18,
            ),
            Text(
              'Something went wrong!',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
