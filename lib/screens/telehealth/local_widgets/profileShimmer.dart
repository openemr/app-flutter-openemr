import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';

Widget profileShimmer(BuildContext context) {
  return GFShimmer(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: 40,
      ),
      Container(
        height: 100,
        width: MediaQuery.of(context).size.width * 0.8,
        color: Colors.white,
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 40,
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
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width * 0.7,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Container(
              height: 20,
              width: MediaQuery.of(context).size.width * 0.7,
              color: Colors.white,
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            height: 100,
            width: 100,
            color: Colors.white,
          ),
          Container(
            margin: const EdgeInsets.all(5),
            height: 100,
            width: 100,
            color: Colors.white,
          ),
          Container(
            margin: const EdgeInsets.all(5),
            height: 100,
            width: 100,
            color: Colors.white,
          ),
        ],
      )
    ],
  ));
}
