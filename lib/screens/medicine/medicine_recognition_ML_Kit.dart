import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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
  var _imageText = [];
  var _drugList = [];
  File image;
  ImagePicker imagePicker;

  String baseURL = "https://dailymed.nlm.nih.gov/dailymed/services";
  String version = "v2";
  String endpoint = "drugnames";
  String format = "json";
  String parameter_1 = "drug_name";

  _callAPI(String drugName) async {
    try {
      final response = await http
          .get('$baseURL/$version/$endpoint\.$format?$parameter_1=$drugName');
      print(response);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.isNotEmpty) {
          int drugCount = data["metadata"]["total_elements"];
          if (drugCount > 0) {
            setState(() {
              _drugList.add(drugName);
            });
          }
        }
      }
    } on Exception catch (_) {
      setState(() {
        _drugList.clear();
        _drugList.add("No data available");
      });
    }
  }

  captureFromCamera() async {
    setState(() {
      image = null;
      _imageText.clear();
      _drugList.clear();
    });
    try {
      PickedFile pickedFile =
          await imagePicker.getImage(source: ImageSource.camera);
      File imageNew = File(pickedFile.path);
      setState(() {
        image = imageNew;
        convertImageToText();
      });
    } on Exception catch (e) {
      //print e to snackbar
      print(e);
    }
  }

  chooseFromGalery() async {
    setState(() {
      image = null;
      _imageText.clear();
      _drugList.clear();
    });
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

    setState(() {
      for (TextBlock textBlock in visionText.blocks) {
        for (TextLine textLine in textBlock.lines) {
          for (TextElement textElement in textLine.elements) {
            //remove all special symbols from string
            _imageText
                .add(textElement.text.replaceAll(new RegExp(r'[^\w\s]+'), ''));
          }
        }
      }
      //remove duplicates
      _imageText = _imageText.toSet().toList();
      for (String item in _imageText) {
        _callAPI(item);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    imagePicker = ImagePicker();
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
            'Medicine Recognition',
            style: TextStyle(fontSize: 17),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: (image == null)
                  ? Icon(
                      Icons.search,
                      size: 150,
                      color: Colors.grey.withOpacity(0.44),
                    )
                  : Column(
                      children: [
                        Text(
                          "Captured Image",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.purple),
                        ),
                        SizedBox(height: 10.0),
                        Image.file(
                          image,
                          width: 140,
                          height: 192,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: 20.0),

                        Text(
                          "All words found in the image",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.purple),
                        ),
                        SizedBox(height: 10.0),
                        Text(_imageText.toString()),
                        SizedBox(height: 20.0),
                        Text(
                          "Medicine words",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.purple),
                        ),
                        SizedBox(height: 10.0),
                        Text(_drugList.toString()),
                        // (_drugs.isNotEmpty) ? Text(_drugs) : Text("No data available"),
                      ],
                    ),
            ),
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
