import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:openemr/utils/rest_ds.dart';
import 'package:openemr/utils/system_padding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicineRecognitionPage extends StatefulWidget {
  @override
  _MedicineRecognitionPageState createState() =>
      _MedicineRecognitionPageState();
}

class _MedicineRecognitionPageState extends State<MedicineRecognitionPage> {
  String _result = "";
  String serverIP = "";
  String tempIP = "";
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _loadIp();
    super.initState();
  }

  _loadIp() async {
    final prefs = await SharedPreferences.getInstance();
    serverIP =
        prefs.getString("webrtcIP") == null ? "" : prefs.getString("webrtcIP");
  }

  _translateImage(File img) async {
    if (serverIP == null || serverIP == "") {
      _showSnackBar("Please set IP using setting button on top right");
    } else {
      RestDatasource api = new RestDatasource();
      var result = await api.textRecognition(img, serverIP);
      print(result);
      if (result["err"] != null) {
        _showSnackBar(result["err"].toString());
      } else {
        this.setState(() {
          _result = result["data"];
        });
      }
    }
  }

  _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  _updateServerIp() async {
    await showDialog<String>(
      context: context,
      child: new SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  onChanged: (value) {
                    this.setState(() {
                      tempIP = value;
                    });
                  },
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Server IP', hintText: 'eg. 10.0.0.1'),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('Update'),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString("webrtcIP", tempIP);
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            MedicineRecognitionPage()),
                  );
                })
          ],
        ),
      ),
    );
  }

  bool fav = false;
  @override
  Widget build(BuildContext context) => Scaffold(
      key: scaffoldKey,
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
            'Text Recognition',
            style: TextStyle(fontSize: 17),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              tooltip: "Logout",
              color: GFColors.DANGER,
              onPressed: () => _updateServerIp(),
            ),
          ]),
      body: Center(
        child: (_result == null || _result == "")
            ? Icon(
                Icons.search,
                size: 150,
                color: Colors.grey.withOpacity(0.44),
              )
            : Text(_result),
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
              onPressed: () async {
                File result = await ImagePicker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                  maxHeight: 400,
                  maxWidth: 400,
                );

                if (result != null) {
                  _translateImage(result);
                }
              },
              child: Icon(Icons.camera),
            ),
            FloatingActionButton(
              heroTag: null,
              backgroundColor: GFColors.DARK,
              onPressed: () async {
                File result = await ImagePicker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                  maxHeight: 400,
                  maxWidth: 400,
                );

                if (result != null) {
                  _translateImage(result);
                }
              },
              child: Icon(Icons.file_upload),
            )
          ],
        ),
      ));
}
