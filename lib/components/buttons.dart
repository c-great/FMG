import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final String title;
  final VoidCallback callback;

  LargeButton({this.title, this.callback});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: RaisedButton(
          onPressed: this.callback,
          child: Text(this.title),
        )
    );
  }

}
