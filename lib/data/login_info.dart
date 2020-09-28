import 'dart:convert';

class LoginInfo {
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