import 'navbar.dart';
import 'package:flutter/material.dart';

class BikeGrid extends StatelessWidget {
  final numbers = List.generate(100, (index) => '$index');
  
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Bike Kollective"),
      ), // AppBar
      body: BuildGridView(),
    ); // Scaffold

  Widget BuildGridView() => GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
    ),
    itemCount: numbers.length,
    itemBuilder: (context, index) {
      final item = numbers[index];

      return BuildNumber(item);
    }

  ); // GridView.builder

  Widget BuildNumber(String number) => Container(
    padding: EdgeInsets.all(16),
    color: Colors.blue,
    child: GridTile(
      header: Text(
        'Header $number',
        textAlign: TextAlign.center, 
      ), // Text
      child: Center(
        child: Text(
          number,
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ); // Container
}