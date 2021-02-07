import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/providers/drink_water_provider.dart';

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
  String _notificationPeriodSelected;

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

  void _updateProfile() {
    // TODO validate all forms

    final weight = int.parse(_weightController.text);
    final oneTapStep = int.parse(_stepsOneTapController.text);
    final doubleTapStep = int.parse(_stepsDoubleTapController.text);
    final notificationPeriod =
        Provider.of<DrinkWaterProvider>(context, listen: false)
            .notificationPeriodList[_notificationPeriodSelected];

    Provider.of<DrinkWaterProvider>(context, listen: false).updateProfile(
      _genderSelected,
      weight,
      _activitiesSelected,
      oneTapStep,
      doubleTapStep,
      notificationPeriod,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrinkWaterProvider>(
      builder: (context, viewModel, child) {
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
                          if (value == '')
                            return 'Double tap bottle water amount';
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
                        items: viewModel.notificationPeriodList.keys
                            .map((label) => DropdownMenuItem(
                                  child: Text(label),
                                  value: label,
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => _notificationPeriodSelected = value);
                        },
                        validator: (value) {
                          if (value == '') return 'Choose notification period';
                          return null;
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
                        items: viewModel.genderList
                            .map((label) => DropdownMenuItem(
                                  child: Text(label),
                                  value: label,
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => _genderSelected = value);
                        },
                        validator: (value) {
                          if (value == '') return 'Set your gender';
                          return null;
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
                        items: viewModel.activitiesList
                            .map((label) => DropdownMenuItem(
                                  child: Text(label),
                                  value: label,
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => _activitiesSelected = value);
                        },
                        validator: (value) {
                          if (value == '') return 'Set your activity level';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                _getFormsDivider(),
                RaisedButton(
                  child: Text('Update'),
                  onPressed: _updateProfile,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
