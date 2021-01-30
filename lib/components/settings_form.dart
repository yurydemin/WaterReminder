import 'package:flutter/material.dart';

class SettingsForm extends StatefulWidget {
  SettingsForm({Key key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Settings'),
    );
  }
}
