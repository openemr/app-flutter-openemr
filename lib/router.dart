import 'package:flutter/material.dart';
import 'package:openemr/interface/chat/chat.dart';
import 'package:openemr/interface/comingSoon.dart';
import 'package:openemr/interface/home/home.dart';
import 'package:openemr/interface/login/login.dart';
import 'package:openemr/interface/ml_vision/camera_preview_scanner.dart';
import 'package:openemr/interface/ml_vision/material_barcode_scanner.dart';
import 'package:openemr/interface/ml_vision/ml_vision.dart';
import 'package:openemr/interface/ml_vision/picture_scanner.dart';
import 'package:openemr/interface/qrCode/qr_code.dart';
import 'package:openemr/interface/patientList/patientList.dart';
import 'package:openemr/interface/heartRate/heartRate.dart';

final routes = {
  '/login': (BuildContext context) => new LoginScreen(),
  '/comingSoon': (BuildContext context) => new ComingSoon(),
  '/home': (BuildContext context) => new HomeScreen(),
  '/qrCode': (BuildContext context) => new QrCode(),
  '/patientList': (BuildContext context) => new PatientList(),
  '/heartRate': (BuildContext context) => new HeartRate(),
  '/chat': (BuildContext context) => new Chat(),
  '/mlKit': (BuildContext context) => new MlVision(),
  '/PictureScanner': (BuildContext context) => PictureScanner(),
  '/CameraPreviewScanner': (BuildContext context) => CameraPreviewScanner(),
  '/MaterialBarcodeScanner': (BuildContext context) =>
      const MaterialBarcodeScanner(),
};
