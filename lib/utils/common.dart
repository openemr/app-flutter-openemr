import 'package:flutter/material.dart';

void showToast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}

bool isValidUrl(url) {
  return Uri.parse(url).isAbsolute;
}
