import 'dart:async';

import 'package:openemr/data/database_helper.dart';
import 'package:openemr/utils/network.dart';
import 'package:openemr/models/user.dart';
import 'package:openemr/models/patient.dart';

var db = new DatabaseHelper();
var baseUrl = "";
var token = "";

class RestDatasource {
  RestDatasource() {
    initState();
  }
  void initState() async {
    baseUrl = await db.getBaseUrl();
    token = await db.getToken();
  }

  NetworkUtil _netUtil = new NetworkUtil();
  static final LOGIN_URL = "/apis/api/auth";

  Future<User> login(String username, String password, String url) {
    return _netUtil.post(url+LOGIN_URL, body: {
      "grant_type": "password",
      "username": username,
      "password": password,
      "scope": "default"
    }).then((dynamic res) {
      if(res == null) throw new Exception("Invalid Login Credentials");
      res['username'] = username;
      res['baseUrl'] = url;
      return new User.map(res);
    });
  }

  Future<List<Patient>> getPatientList({Map fname, lname, dob}) {
    Map<String, String> headers = {"Authorization": token};
    return _netUtil
        .get(baseUrl + "/apis/api/patient", headers: headers)
        .then((dynamic res) {
      if (res == null) throw new Exception("Error fetching data");
      var patientList = new List<Patient>();
      res.forEach((patient) => {patientList.add(Patient.map(patient))});
      return patientList;
    });
  }
}
