import 'package:flutter/material.dart';
import 'package:openemr/interface/home/home.dart';
import 'package:openemr/interface/login/login.dart';
import 'package:openemr/interface/qrCode/qr_code.dart';

final routes = {
  '/login':         (BuildContext context) => new LoginScreen(),
  '/home':         (BuildContext context) => new HomeScreen(),
  '/qrCode':         (BuildContext context) => new QrCode(),
  '/' :          (BuildContext context) => new LoginScreen(),
};