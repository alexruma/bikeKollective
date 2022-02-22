import 'package:bike_kollective/src/account.dart';
import 'package:bike_kollective/src/bikes.dart';
import 'package:bike_kollective/src/set_up_account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bike_kollective/src_exports.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavBarPage extends StatefulWidget {
  const NavBarPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  int _selectedIndex = 0;
  String _titleText = "Bike Kollective";

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
      _titleText = _titles[_selectedIndex];
    });
  }

  final List<Widget> _pages = [
    Gmaps(),
    MyHomePage(title: "Home"),
    BikeGrid(),
    AccountPage()
  ];

  final List<String> _titles = const [
    "Bike Kollective",
    "Bike Search",
    "Bike List",
    "My Account"
  ];

  Future<bool> asyncUidCheck() async {
    bool inDB = await CheckForUser.checkDbForUid(
        FirebaseAuth.instance.currentUser?.uid);

    if (inDB == false) {
      setState(() {});
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SetUpPage()));
    }
    return inDB;
  }

  @override
  // Check if firebase_auth uid corresponds to document in db.
  void initState() {
    asyncUidCheck().then((value) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(_titleText),
          )),
          GestureDetector(
            child: Text('Get User'),
            onTap: () async {
              final FirebaseAuth auth = FirebaseAuth.instance;
              //User user = auth.currentUser;
              print(auth.currentUser?.uid);
              setState(() {});
            },
          )
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOutAction,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
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
            label: 'Bike List',
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
  }

  // Function that executes on tap of Sign Out button/text.
  void signOutAction() {
    FirebaseAuth.instance.signOut();
    setState(() {});
    Navigator.of(context).pushReplacementNamed('/sign-in');
  }
}
