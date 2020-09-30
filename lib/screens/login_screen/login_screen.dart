import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmg_remote_work_tracker/components/alert.dart';
import 'package:fmg_remote_work_tracker/data/user_details.dart';
import 'package:fmg_remote_work_tracker/data/login_info.dart';
import 'package:fmg_remote_work_tracker/screens/home_screen/home_screen.dart';
import 'package:fmg_remote_work_tracker/server_interaction/basic_interaction.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  TextStyle style = TextStyle(fontSize: 20.0);

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  TextField getLoginTextField(String hintText, bool shouldObscure,
      TextEditingController controller, Iterable<String> autoFillHints) {
    return TextField(
      autofillHints: autoFillHints,
      obscureText: shouldObscure,
      controller: controller,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(
              color: Theme.of(context).primaryColorLight, width: 1.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userNameField = getLoginTextField(
        "User Name", false, userNameController, [AutofillHints.username]);
    final passwordField = getLoginTextField(
        "Password", true, passwordController, [AutofillHints.password]);

    void loginButtonAction() async {
      LoginInfo.username = userNameController.text;
      LoginInfo.password = passwordController.text;

      try {
        user = await getEmployee();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage(title: 'FMG - Remote Work Tracker')),
        );
        // clear password once successful at logging in
        passwordController.clear();
        setRegistrationToken();
      } catch (e) {
        showAlert(context, "Login Failure", e.toString());
      }
    }

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: loginButtonAction,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/fmg-logo.png",
                  fit: BoxFit.contain,
                ),
                Text(
                  "Remote Work Compliance App",
                  style: Theme.of(context).primaryTextTheme.headline1,
                ),
                SizedBox(height: 45.0),
                AutofillGroup(
                  child: Column(
                    children: [
                      userNameField,
                      SizedBox(height: 25.0),
                      passwordField,
                    ],
                  ),
                ),
                SizedBox(
                  height: 35.0,
                ),
                loginButton,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
