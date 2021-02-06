import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_reminder/components/drink_water_view.dart';
import 'package:water_reminder/components/settings_form.dart';
import 'package:water_reminder/components/stats_table.dart';
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
    // init prepared lists
    Provider.of<DrinkWaterProvider>(context, listen: false).baseInit();
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
            label: 'Stats',
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
                StatsTable(),
                DrinkWaterView(),
                SettingsForm(),
              ],
            ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    //check first run
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
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

  void _initProfile() {
    // TODO validate form
    Provider.of<DrinkWaterProvider>(context, listen: false).initNewProfile();
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
