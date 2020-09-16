import 'package:flutter/material.dart';

class SelectFromListScreen extends StatelessWidget {
  final String title;
  final Function listGenFunction;

  const SelectFromListScreen({Key key, this.title, this.listGenFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> listItems = listGenFunction(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: [
          Wrap(
            runSpacing: 5,
            children: listItems,
          ),
        ],
      )
    );
  }

}