import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';

Widget listItemShimmer(BuildContext context) {
  return GFShimmer(
    child: Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width * 0.55,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.5,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget customListLoadingShimmer(BuildContext context,
    {String loadingMessage, int listLength = 1}) {
  return Container(
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width * 0.8,
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        loadingMessage == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  loadingMessage,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
        for (var i = 0; i < listLength; i++) listItemShimmer(context)
      ],
    ),
  );
}
