import 'dart:async';
import 'dart:io';

import 'package:openemr/models/patient.dart';
import 'package:openemr/utils/network.dart';
import 'package:openemr/models/user.dart';
import 'package:openemr/const/strings.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();

  Future<User> login(String username, String password, String url) {
    url = url == null ? "" : url;
    return _netUtil.post(url + loginendpoint, body: {
      "grant_type": "password",
      "username": username,
      "password": password,
      "scope": "default"
    }).then((dynamic res) {
      if (res == null) throw new Exception("Invalid Login Credentials");
      res['username'] = username;
      res['baseUrl'] = url;
      res['password'] = password;
      return new User.map(res);
    });
  }

  Future<List<Patient>> getPatientList(baseUrl, token) {
    Map<String, String> headers = {"Authorization": token};
    return _netUtil
        .get(baseUrl + patientendpoint, headers: headers)
        .then((dynamic res) {
      if (res == null) throw new Exception("Error fetching data");
      var patientList = new List<Patient>.empty(growable: true);
      if (res["data"] != null) {
        res = res["data"];
      }
      res.forEach((patient) => {patientList.add(Patient.map(patient))});
      return patientList;
    });
  }

  Future<dynamic> addPatient({
    baseUrl,
    token,
    title,
    fname,
    mname,
    lname,
    dob,
    sex,
    street,
    postalcode,
    city,
    state,
    countrycode,
    phonecontact,
    race,
    ethnicity,
  }) {
    Map<String, String> headers = {"Authorization": token};
    return _netUtil.post(baseUrl + addpatientendpoint, headers: headers, body: {
      "title": title,
      "fname": fname,
      "mname": mname,
      "lname": lname,
      "DOB": dob,
      "sex": sex,
      "street": street,
      "postal_code": postalcode,
      "city": city,
      "state": state,
      "country_code": countrycode,
      "phone_contact": phonecontact,
      "race": race,
      "ethnicity": ethnicity,
    }).then((dynamic res) {
      if (res["data"] != null) {
        res = res["data"];
      }
      return res;
    });
  }

  Future<dynamic> textRecognition(File img, ip) {
    return _netUtil
        .upload("https://" + ip + ":8086/ocrImage", img)
        .then((dynamic res) {
      return res;
    });
  }
}
