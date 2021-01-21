import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/';
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AfterLayoutMixin<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Reminder'),
        centerTitle: true,
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // check first run

    // intro dialog
    //showIntroDialog();
  }

  void showIntroDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Intro Dialog'),
        actions: <Widget>[
          FlatButton(
            child: Text('Continue'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
