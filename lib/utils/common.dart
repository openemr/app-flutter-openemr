import 'package:flutter/material.dart';

void showToast(BuildContext context, String msg) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}

bool isValidUrl(url) {
  return Uri.parse(url).isAbsolute;
}
