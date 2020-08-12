import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';

class MedicineRecognitionPage extends StatefulWidget {
  @override
  _MedicineRecognitionPageState createState() =>
      _MedicineRecognitionPageState();
}

class _MedicineRecognitionPageState extends State<MedicineRecognitionPage> {
  @override
  void initState() {
    super.initState();
  }

  bool fav = false;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: GFAppBar(
        backgroundColor: GFColors.DARK,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              child: Icon(
                CupertinoIcons.back,
                color: GFColors.SUCCESS,
              ),
            )),
        title: const Text(
          'Medicine Recognition',
          style: TextStyle(fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Icon(
          Icons.search,
          size: 150,
          color: Colors.grey.withOpacity(0.44),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              heroTag: null,
              backgroundColor: GFColors.DARK,
              onPressed: () {},
              child: Icon(Icons.camera),
            ),
            FloatingActionButton(
              heroTag: null,
              backgroundColor: GFColors.DARK,
              onPressed: () {},
              child: Icon(Icons.file_upload),
            )
          ],
        ),
      ));
}
