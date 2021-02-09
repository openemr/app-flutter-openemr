import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:image_picker/image_picker.dart';

class MedicineRecognitionMLKit extends StatefulWidget {
  @override
  _MedicineRecognitionMLKitState createState() =>
      _MedicineRecognitionMLKitState();
}

class _MedicineRecognitionMLKitState extends State<MedicineRecognitionMLKit> {
  String _result = "";
  File image;
  ImagePicker imagePicker;

  captureFromCamera() async {
    try {
      PickedFile pickedFile =
          await imagePicker.getImage(source: ImageSource.camera);
      File imageNew = File(pickedFile.path);
      setState(() {
        image = imageNew;
        convertImageToText();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  chooseFromGalery() async {
    try {
      PickedFile pickedFile =
          await imagePicker.getImage(source: ImageSource.gallery);
      File imageNew = File(pickedFile.path);
      setState(() {
        image = imageNew;
        convertImageToText();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  convertImageToText() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(image);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    VisionText visionText =
        await textRecognizer.processImage(firebaseVisionImage);
    _result = "";

    setState(() {
      for (TextBlock textBlock in visionText.blocks) {
        final String text = textBlock.text;

        for (TextLine textLine in textBlock.lines) {
          for (TextElement textElement in textLine.elements) {
            _result += textElement.text + " ";
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ),
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
                  captureFromCamera();
                },
                child: Icon(Icons.camera),
              ),
              FloatingActionButton(
                heroTag: null,
                backgroundColor: GFColors.DARK,
                onPressed: () async {
                  chooseFromGalery();
                },
                child: Icon(Icons.file_upload),
              )
            ],
          ),
        ));
  }
}
