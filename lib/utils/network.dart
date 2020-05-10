import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'common.dart';

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url, {Map headers}) {
    if (!isValidUrl(url)) {
      return Future.error("Invalid API URL");
    }
    return http.get(url, headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    if (!isValidUrl(url)) {
      return Future.error("Invalid API URL");
    }
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode == 401) {
        throw new Exception(statusCode.toString() + "Invalid Credentials");
      } else if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception(
            statusCode.toString() + "Error while fetching data");
      }

      return _decoder.convert(res);
    });
  }
}
