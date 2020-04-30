import 'package:flutter/material.dart';
import 'package:openemr/interface/home/home.dart';
import 'package:openemr/interface/login/login.dart';
import 'package:openemr/interface/qrCode/qr_code.dart';
import 'package:openemr/interface/patientList/patientList.dart';
import 'package:openemr/interface/heartRate/heartRate.dart';

final routes = {
  '/login':         (BuildContext context) => new LoginScreen(),
  '/home':          (BuildContext context) => new HomeScreen(),
  '/qrCode':        (BuildContext context) => new QrCode(),
  '/patientList':   (BuildContext context) => new PatientList(),
  '/heartRate':   (BuildContext context) => new HeartRate(),
  '/' :             (BuildContext context) => new LoginScreen(),
};