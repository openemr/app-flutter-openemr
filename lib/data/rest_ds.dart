import 'dart:async';

import 'package:openemr/utils/network.dart';
import 'package:openemr/models/user.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://192.168.225.75";
  static final LOGIN_URL = BASE_URL + "/apis/api/auth";

  Future<User> login(String username, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      "grant_type": "password",
      "username": username,
      "password": password,
      "scope": "default"
    }).then((dynamic res) {
      // print(res.toString());
      if(res == null) throw new Exception("Invalid Login Credentials");
      res['username'] = username;
      return new User.map(res);
    });
  }
}