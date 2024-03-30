import 'package:flutter/material.dart';
import 'views/deck_list.dart';

void main() async {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.green, // Set primary color to green
    ),
    home: DeckList(),
    debugShowCheckedModeBanner: false,
  ));
}
