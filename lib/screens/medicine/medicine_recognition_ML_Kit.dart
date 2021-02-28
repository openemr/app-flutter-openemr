import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MedicineRecognitionMLKit extends StatefulWidget {
  @override
  _MedicineRecognitionMLKitState createState() =>
      _MedicineRecognitionMLKitState();
}

class _MedicineRecognitionMLKitState extends State<MedicineRecognitionMLKit> {
  var _imageText = [];
  var _drugList = [];
  var _selectedDrugList = [];
  File image;
  ImagePicker imagePicker;

  String baseURL = "https://dailymed.nlm.nih.gov/dailymed/services";
  String version = "v2";
  String endpoint = "drugnames";
  String format = "json";
  String parameter_1 = "drug_name";

  final scaffoldKey1 = new GlobalKey<ScaffoldState>();

  //decides when to active/inactive spinner indicator
  bool showSpinner = false;

  void _showSnackBar(String text) {
    scaffoldKey1.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

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
            return true;
          }
        }
      }
    } on Exception catch (e) {
      setState(() {
        _drugList.clear();
        showSpinner = false;
      });
      return false;
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
      _showSnackBar("An unexpected error occured.");

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
        convertImageToText().whenComplete(() {showSpinner = false; });

      });
    } on Exception catch (e) {
      setState(() {
        showSpinner = false;
      });
      _showSnackBar("An unexpected error occured.");

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
      //call the api
      for (String item in _imageText) {
        bool success = _callAPI(item);
        if (!success) {
          _showSnackBar("Please check your internet connectivity.");
          break;
        }
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
        key: scaffoldKey1,
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
        body: ModalProgressHUD(
          // color: Colors.purple,
          inAsyncCall: showSpinner,
          child: Center(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  "Captured Image",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.purple),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Image.file(
                            image,
                            width: 140,
                            height: 192,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  "All words found in the image",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.purple),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          _imageText.length == 0
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 3.0, right: 3.0, bottom: 5.0),
                                  padding: const EdgeInsets.only(
                                      top: 3.0,
                                      left: 17.0,
                                      right: 17.0,
                                      bottom: 3.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                          color: Colors.black, width: 1.0)),
                                  child: Text(
                                    "No data available",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.red),
                                  ),
                                )
                              : Container(
                                  height: _imageText.length < 4
                                      ? 160.0
                                      : _imageText.length * 40.0,
                                  margin: const EdgeInsets.only(
                                      left: 3.0, right: 3.0, bottom: 5.0),
                                  padding: const EdgeInsets.only(
                                      top: 3.0,
                                      left: 17.0,
                                      right: 17.0,
                                      bottom: 3.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                          color: Colors.black, width: 1.0)),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: _imageText.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10.0),
                                            RaisedButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 3,
                                                    child: Icon(Icons.add),
                                                  ),
                                                  Expanded(
                                                    flex: 10,
                                                    child:
                                                        Text(_imageText[index]),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  final words =
                                                      _selectedDrugList
                                                          .firstWhere(
                                                              (element) =>
                                                                  element ==
                                                                  _imageText[
                                                                      index],
                                                              orElse: () {
                                                    return null;
                                                  });
                                                  if (words == null) {
                                                    _selectedDrugList
                                                        .add(_imageText[index]);
                                                  }
                                                });
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  "Medicines related keywords",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.purple),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          _drugList.length == 0
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 3.0, right: 3.0, bottom: 5.0),
                                  padding: const EdgeInsets.only(
                                      top: 3.0,
                                      left: 17.0,
                                      right: 17.0,
                                      bottom: 3.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                          color: Colors.black, width: 1.0)),
                                  child: Text(
                                    "No data available",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.red),
                                  ),
                                )
                              : Container(
                                  height: _drugList.length < 4
                                      ? 160.0
                                      : _drugList.length * 40.0,
                                  margin: const EdgeInsets.only(
                                      left: 3.0, right: 3.0, bottom: 5.0),
                                  padding: const EdgeInsets.only(
                                      top: 3.0,
                                      left: 17.0,
                                      right: 17.0,
                                      bottom: 3.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                          color: Colors.black, width: 1.0)),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: _drugList.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10.0),
                                            RaisedButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 3,
                                                    child: Icon(Icons.add),
                                                  ),
                                                  Expanded(
                                                    flex: 10,
                                                    child:
                                                        Text(_drugList[index]),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  final drug = _selectedDrugList
                                                      .firstWhere(
                                                          (element) =>
                                                              element ==
                                                              _drugList[index],
                                                          orElse: () {
                                                    return null;
                                                  });
                                                  if (drug == null) {
                                                    _selectedDrugList
                                                        .add(_drugList[index]);
                                                  }
                                                });
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  "Selected Drug List",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.purple),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          _selectedDrugList.length == 0
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 3.0, right: 3.0, bottom: 5.0),
                                  padding: const EdgeInsets.only(
                                      top: 3.0,
                                      left: 17.0,
                                      right: 17.0,
                                      bottom: 3.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                          color: Colors.black, width: 1.0)),
                                  child: Text(
                                    "No data available",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.red),
                                  ),
                                )
                              : Container(
                                  height: _selectedDrugList.length < 4
                                      ? 160.0
                                      : _selectedDrugList.length * 40.0,
                                  margin: const EdgeInsets.only(
                                      left: 3.0, right: 3.0, bottom: 5.0),
                                  padding: const EdgeInsets.only(
                                      top: 3.0,
                                      left: 17.0,
                                      right: 17.0,
                                      bottom: 3.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                          color: Colors.black, width: 1.0)),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: _selectedDrugList.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10.0),
                                            RaisedButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 3,
                                                    child: Icon(Icons.remove),
                                                  ),
                                                  Expanded(
                                                    flex: 10,
                                                    child: Text(
                                                        _selectedDrugList[
                                                            index]),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _selectedDrugList.remove(
                                                      _selectedDrugList[index]);
                                                });
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                          SizedBox(height: 20.0),
                        ],
                      ),
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
                  showSpinner = true;
                  captureFromCamera();
                },
                child: Icon(Icons.camera),
              ),
              FloatingActionButton(
                heroTag: null,
                backgroundColor: GFColors.DARK,
                onPressed: () async {
                  showSpinner = true;
                  chooseFromGalery();
                },
                child: Icon(Icons.file_upload),
              )
            ],
          ),
        ));
  }
}
