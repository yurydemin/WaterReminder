import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/';
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AfterLayoutMixin<HomeView>, SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentTabIndex = 1;
  bool _isLoading = true;

  _tabListener() {
    setState(() {
      _currentTabIndex = _tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        title: Text('Water Reminder'),
        centerTitle: true,
      ),
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
                Container(
                  color: Colors.orange,
                ),
                Container(
                  color: Colors.purple,
                ),
                Container(
                  color: Colors.yellow,
                ),
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
    setState(() {
      _isLoading = false;
    });
  }

  void _initProfile() {
    Navigator.of(context).pop();
    setState(() {
      _isLoading = false;
    });
  }

  void _showIntroDialog() {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Text('Intro Dialog'),
          actions: <Widget>[
            FlatButton(
              child: Text('Done'),
              onPressed: _initProfile,
            )
          ],
        ),
      ),
    );
  }
}
