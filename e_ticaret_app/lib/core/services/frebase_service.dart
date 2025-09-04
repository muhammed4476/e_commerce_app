import 'dart:convert';
import 'dart:io';

import 'package:e_ticaret_app/core/model/user/user_auth_error.dart';

import 'package:e_ticaret_app/core/model/user/user_request.dart';

import 'package:http/http.dart' as http;

class FirebaseService {
  static const String FIREBASE_URL = "https://hwafire-e9adf-default-rtdb.firebaseio.com/";
  static const String FIREBASE_AUTH_URL =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAinidWPKET4SXAv7MDruCJPJUuKnZ6Ngs";

  Future postUser(UserRequest request) async {
    var jsonModel = json.encode(request.toJson());
    final response = await http.post(Uri.parse(FIREBASE_AUTH_URL), body: jsonModel);
    switch (response.statusCode) {
      case HttpStatus.ok:
        return true;
      default:
        var errorModel = json.decode(response.body);
        var error = FirebaseAuthError.fromJson(errorModel);
        return error;
    }
  }
}
