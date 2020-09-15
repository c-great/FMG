import 'dart:convert';

class LoginInfo {
  //fixme: these should not be hard-coded, we need a log in screen
  static String username;
  static String password;

  static String getEncodedLogin() {
    var bytes = utf8.encode(username + ":" + password);
    return base64.encode(bytes);
  }

  static void clear() {
    username = '';
    password = '';
  }
}