import 'package:flutter/material.dart';
import 'package:openemr/interface/home/home.dart';
import 'package:openemr/interface/login/login.dart';

final routes = {
  '/login':         (BuildContext context) => new LoginScreen(),
  '/home':         (BuildContext context) => new HomeScreen(),
  '/' :          (BuildContext context) => new LoginScreen(),
};