import 'package:flutter/material.dart';

void buildDialog(BuildContext context, String title, String message) {
  var _defaultBorder = BorderRadius.circular(10);
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: _defaultBorder),
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(
          child: Text(title),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 80,
            maxWidth: 80,
          ),
          child: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    },
  );
}
