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
  }
}
