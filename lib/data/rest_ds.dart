import 'dart:async';

import 'package:openemr/utils/network.dart';
import 'package:openemr/models/user.dart';

class RestDatasource {
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
      return new User.map(res);
    });
  }
}