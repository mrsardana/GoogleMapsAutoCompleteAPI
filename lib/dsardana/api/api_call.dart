import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APICall {
  static Future<Map<String, dynamic>?> fetchUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      Map<String, dynamic> responseModel = {};
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        responseModel['predictions'] = data['predictions'];
        return responseModel;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<Map<String, dynamic>?> fetchLatLong(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      Map<String, dynamic> responseModel = {};
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        responseModel['results'] = data['results'][0];
        return responseModel;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
