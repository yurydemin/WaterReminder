import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_reminder/models/common.dart';
import 'package:water_reminder/extensions/string_extension.dart';

class SettingsForm extends StatefulWidget {
  SettingsForm({Key key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  GlobalKey<FormState> _stepsFormKey = GlobalKey<FormState>();
  TextEditingController _stepsOneTapController = TextEditingController();
  TextEditingController _stepsDoubleTapController = TextEditingController();

  GlobalKey<FormState> _notificationsFormKey = GlobalKey<FormState>();
  final List<String> _notificationsPeriodList = [
    '1 hour',
    '2 hours',
    '3 hours',
    '6 hours',
    'None',
  ];
  String _notificationPeriodSelected;

  // enums -> comboboxitem
  List<String> _genderList;
  List<String> _activitiesList;

  // intro dialog form
  GlobalKey<FormState> _introDialogFormKey = GlobalKey<FormState>();
  TextEditingController _weightController = TextEditingController();
  String _genderSelected;
  String _activitiesSelected;

  Widget _getFormsDivider() {
    return Divider(
      color: Colors.black,
      height: 40,
      thickness: 2,
      indent: 10,
      endIndent: 10,
    );
  }

  @override
  void initState() {
    super.initState();
    _notificationPeriodSelected = _notificationsPeriodList[0];
    // enums -> comboboxitem
    _genderList = EnumToString.toList<Gender>(Gender.values)
        .map((value) => value.firstLetterCap())
        .toList();
    _activitiesList = EnumToString.toList<Activity>(Activity.values)
        .map((value) => value.firstLetterCap())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _getFormsDivider(),
            Text("Steps"),
            Form(
              key: _stepsFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _stepsOneTapController,
                    validator: (value) {
                      if (value == '') return 'One tap bottle water amount';
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'One tap drink',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  TextFormField(
                    controller: _stepsDoubleTapController,
                    validator: (value) {
                      if (value == '') return 'Double tap bottle water amount';
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Double tap drink',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ],
              ),
            ),
            _getFormsDivider(),
            Text("Notifications"),
            Form(
              key: _notificationsFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Notification Period',
                    ),
                    value: _notificationPeriodSelected,
                    items: _notificationsPeriodList
                        .map((label) => DropdownMenuItem(
                              child: Text(label),
                              value: label,
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _notificationPeriodSelected = value);
                    },
                  ),
                ],
              ),
            ),
            _getFormsDivider(),
            Text("Personal"),
            Form(
              key: _introDialogFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                    ),
                    value: _genderSelected,
                    items: _genderList
                        .map((label) => DropdownMenuItem(
                              child: Text(label),
                              value: label,
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _genderSelected = value);
                    },
                  ),
                  TextFormField(
                    controller: _weightController,
                    validator: (value) {
                      if (value == '') return 'Input your weight';
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Weight',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Activity',
                    ),
                    value: _activitiesSelected,
                    items: _activitiesList
                        .map((label) => DropdownMenuItem(
                              child: Text(label),
                              value: label,
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _activitiesSelected = value);
                    },
                  ),
                ],
              ),
            ),
            _getFormsDivider(),
            RaisedButton(
              child: Text('Update'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
