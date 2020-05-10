import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openemr/utils/common.dart';

class QrCode extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<QrCode> {
  String barcode = "Click on scan button";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        title: new Text('QR/Barcode Scanner'),
      ),
      body: Builder(
          builder: (context) => new Center(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      child: new MaterialButton(
                        onPressed: () => scan(context),
                        child: new Text(
                          "Scan",
                        ),
                        color: Theme.of(context).iconTheme.color,
                      ),
                      padding: const EdgeInsets.all(8.0),
                    ),
                    new Text(barcode),
                  ],
                ),
              )),
    );
  }

  Future scan(context) async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      Clipboard.setData(ClipboardData(text: barcode));
      bool _validURL = Uri.parse(barcode).isAbsolute;
      if (_validURL) launchURL(barcode);
      showToast(context, "Data has been copied to clipboard");
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode = '');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
