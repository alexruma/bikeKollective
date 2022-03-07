import 'package:flutter/material.dart';

class RatingStar extends StatelessWidget {
  RatingStar({Key? key, required this.rating}) : super(key: key);

  var rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
          children: List.generate(5, (index) {
        return (Icon(index >= rating ? Icons.star_border : Icons.star,
            color: index >= rating ? Colors.yellow : Colors.yellow));
      })),
    );
  }
}
