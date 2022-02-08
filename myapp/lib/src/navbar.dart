<<<<<<< HEAD
import 'package:flutter/material.dart';

class NavBar {
  static Widget navBar() {
    return BottomNavigationBar(type: BottomNavigationBarType.fixed, items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.location_pin),
        label: 'Map',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Bike Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.directions_bike),
        label: 'Current Bike',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_box),
        label: 'Account',
      ),
    ]);
=======
import 'package:bike_kollective/src/account.dart';
import 'package:flutter/material.dart';
import 'package:bike_kollective/src_exports.dart';
import 'package:flutterfire_ui/auth.dart';

class NavBarPage extends StatefulWidget {
  const NavBarPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  int _selectedIndex = 0;
  String _titleText = "Business Card";

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
      _titleText = _titles[_selectedIndex];
    });
  }

  final List<Widget> _pages = [
    Gmaps(),
    Gmaps(),
    MyHomePage(title: "Home"),
    AuthGate(),
    AccountPage()
  ];

  final List<String> _titles = const [
    "Bike Kollective",
    "Bike Map",
    "Bike Search",
    "Bike List",
    "My Account"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Center(child: Text(_titleText)),
          Image.asset(
            'assets/images/bike-icon.png',
            height: 85,
            width: 85,
          ),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Bike Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike),
            label: 'Current Bike',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _updateIndex,
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
    );
>>>>>>> origin/main
  }
}
