import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';

Widget customListLoadingShimmer(BuildContext context,
    {String loadingMessage, int listLength = 1}) {
  return Container(
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width * 0.8,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        loadingMessage == null
            ? Container()
            : Text(
                loadingMessage,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
        for (var i = 0; i < listLength; i++)
          ListTileShimmer(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.symmetric(vertical: 10),
          )
      ],
    ),
  );
}
