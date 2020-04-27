import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showToast(BuildContext context, String msg) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}

void launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

bool isValidUrl(url) {
  return Uri.parse(url).isAbsolute;
}
