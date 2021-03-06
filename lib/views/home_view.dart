import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/components/drink_water_view.dart';
import 'package:water_reminder/components/settings_form.dart';
import 'package:water_reminder/components/progress_history_table.dart';
import 'package:water_reminder/providers/drink_water_provider.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/';
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AfterLayoutMixin<HomeView>, SingleTickerProviderStateMixin {
  // tabs
  TabController _tabController;
  int _currentTabIndex = 1;
  bool _isLoading = true;

  // intro dialog form
  GlobalKey<FormState> _introDialogFormKey = GlobalKey<FormState>();
  TextEditingController _weightController = TextEditingController();
  String _genderSelected;
  String _activitiesSelected;

  _tabListener() {
    setState(() {
      _currentTabIndex = _tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();
    // tabs
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 1,
    );
    _tabController.addListener(_tabListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (currentIndex) {
          _tabController.index = currentIndex;
          setState(() {
            _currentTabIndex = currentIndex;
            _tabController.animateTo(_currentTabIndex);
          });
        },
        currentIndex: _currentTabIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq_outlined),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController,
              children: <Widget>[
                ProgressHistoryTable(),
                DrinkWaterView(),
                SettingsForm(),
              ],
            ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    // init
    await Provider.of<DrinkWaterProvider>(context, listen: false).baseInit();
    //check first run
    if (Provider.of<DrinkWaterProvider>(context, listen: false).seen) {
      //load already existed profile
      _loadProfile();
    } else {
      //init new profile
      _showIntroDialog();
    }
  }

  void _loadProfile() {
    Provider.of<DrinkWaterProvider>(context, listen: false).loadProfile();
    setState(() {
      _isLoading = false;
    });
  }

  void _initProfile() async {
    // validate
    if (!_introDialogFormKey.currentState.validate()) return;
    // parse form values
    final weight = int.parse(_weightController.text);
    // init new user profile
    await Provider.of<DrinkWaterProvider>(
      context,
      listen: false,
    ).initNewProfile(
      _genderSelected,
      weight,
      _activitiesSelected,
    );

    Navigator.of(context).pop();
    setState(() {
      _isLoading = false;
    });
  }

  void _showIntroDialog() {
    showDialog(
      context: context,
      builder: (context) => Consumer<DrinkWaterProvider>(
        builder: (context, viewModel, child) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              content: Form(
                key: _introDialogFormKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                          if (value == null || value.isEmpty)
                            return 'Set your gender';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _weightController,
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
                          setState(() => _activitiesSelected = value);
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
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Done'),
                  onPressed: _initProfile,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
