import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

void showSettingsDialog(BuildContext context) {
  final BorderRadius borderRadius = BorderRadius.circular(10);
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Center(
          child: Text("Settings"),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 40,
            minWidth: 80,
            maxHeight: 80,
            maxWidth: 80,
          ),
          child: ListTile(
            horizontalTitleGap: 0,
            title: const Text('Delete all cache'),
            leading: const Icon(Icons.cached_rounded),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
            onTap: () async {
              bool result = await OnAudioQuery.clearCachedArtworks();

              SnackBar snackBar = SnackBar(
                content: Row(
                  children: [
                    Icon(
                      result ? Icons.done : Icons.error_outline_rounded,
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    Text(
                      result
                          ? 'All artworks have been deleted'
                          : 'Oops, Something went wrong!',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                backgroundColor: result ? Colors.green : Colors.red,
              );

              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ),
      );
    },
  );
}
