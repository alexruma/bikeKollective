import 'package:bike_kollective/src/bikes.dart';
import 'package:bike_kollective/src/set_up_account.dart';
import 'package:flutter/material.dart';
import 'package:bike_kollective/src_exports.dart';
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

  final List<Widget> _pages = [Gmaps(), AddBike(), BikeList(), AccountPage()];

  final List<String> _titles = const [
    "Bike Kollective",
    "Add Bike",
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
            child: Center(
                child: Text(
              _titleText,
              style: const TextStyle(fontFamily: 'Righteous', fontSize: 24),
            )),
          )),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Bike',
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
