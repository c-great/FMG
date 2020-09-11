import 'dart:convert';

class LoginInfo {
  //fixme: these should not be hard-coded, we need a log in screen
  static String _username = "nmckubre";
  static String _password = "fish";

  static String getEncodedLogin() {
    var bytes = utf8.encode(_username + ":" + _password);
    return base64.encode(bytes);
  }

}