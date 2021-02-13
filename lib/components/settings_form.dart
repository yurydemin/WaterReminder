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
  // settings changed flag
  bool _isChanged = false;

  // form divider
  Widget _getFormsDivider() {
    return Divider(
      color: Colors.black,
      height: 40,
      thickness: 2,
      indent: 10,
      endIndent: 10,
    );
  }

  // drink water steps form
  GlobalKey<FormState> _stepsFormKey = GlobalKey<FormState>();
  TextEditingController _stepsOneTapController = TextEditingController();
  TextEditingController _stepsDoubleTapController = TextEditingController();

  // notifications form
  GlobalKey<FormState> _notificationsFormKey = GlobalKey<FormState>();
  String _notificationPeriodSelected;

  // personal form
  GlobalKey<FormState> _personalFormKey = GlobalKey<FormState>();
  TextEditingController _weightController = TextEditingController();
  String _genderSelected;
  String _activitiesSelected;

  // check settings changed
  void _settingsChanged() {
    setState(() {
      _isChanged = true;
    });
  }

  // save settings to user profile
  void _updateProfile() {
    // validate forms
    var stepsFormValidation = _stepsFormKey.currentState.validate();
    var notificationsFormValidation =
        _notificationsFormKey.currentState.validate();
    var personalFormValidation = _personalFormKey.currentState.validate();
    if (!(stepsFormValidation &&
        notificationsFormValidation &&
        personalFormValidation)) return;

    // save forms states
    _stepsFormKey.currentState.save();
    _notificationsFormKey.currentState.save();
    _personalFormKey.currentState.save();

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

    setState(() {
      _isChanged = false;
    });
  }

  @override
  void initState() {
    super.initState();

    // fill properties from user profile
    _stepsOneTapController.text =
        Provider.of<DrinkWaterProvider>(context, listen: false)
            .oneTapBottleWaterAmount;
    _stepsDoubleTapController.text =
        Provider.of<DrinkWaterProvider>(context, listen: false)
            .doubleTapBottleWaterAmount;
    _notificationPeriodSelected =
        Provider.of<DrinkWaterProvider>(context, listen: false)
            .notificationPeriodTitle;
    _genderSelected =
        Provider.of<DrinkWaterProvider>(context, listen: false).gender;
    _activitiesSelected =
        Provider.of<DrinkWaterProvider>(context, listen: false).activity;
    _weightController.text =
        Provider.of<DrinkWaterProvider>(context, listen: false).weight;
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
                        onChanged: (value) {
                          if (value != viewModel.oneTapBottleWaterAmount) {
                            _settingsChanged();
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Input one tap bottle water amount (ml)';
                          if (int.parse(value) <= 0)
                            return 'Incorrect water amount value';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'One tap drink (ml)',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      TextFormField(
                        controller: _stepsDoubleTapController,
                        onChanged: (value) {
                          if (value != viewModel.doubleTapBottleWaterAmount) {
                            _settingsChanged();
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Input double tap bottle water amount (ml)';
                          if (int.parse(value) <= 0)
                            return 'Incorrect water amount value';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Double tap drink (ml)',
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
                          if (value != _notificationPeriodSelected) {
                            _notificationPeriodSelected = value;
                            _settingsChanged();
                          }
                          //setState(() => _notificationPeriodSelected = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Choose notification period';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                _getFormsDivider(),
                Text("Personal"),
                Form(
                  key: _personalFormKey,
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
                          if (value != _genderSelected) {
                            _genderSelected = value;
                            _settingsChanged();
                          }
                          //setState(() => _genderSelected = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Set your gender';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _weightController,
                        onChanged: (value) {
                          if (value != viewModel.weight) {
                            _settingsChanged();
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Input your weight';
                          if (int.parse(value) <= 0)
                            return 'Incorrect weight value';
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
                          if (value != _activitiesSelected) {
                            _activitiesSelected = value;
                            _settingsChanged();
                          }
                          //setState(() => _activitiesSelected = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Set your activity level';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                _getFormsDivider(),
                if (_isChanged)
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
