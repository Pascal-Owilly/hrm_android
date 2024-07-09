
// lib/styles.dart
import 'package:flutter/material.dart';

// Define text styles
const TextStyle kTitleTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20.0,
);

const TextStyle kSubtitleTextStyle = TextStyle(
  color: Colors.white70,
  fontSize: 14.0,
);

// Define button styles
final ButtonStyle kButtonStyle = ElevatedButton.styleFrom(
  primary: Color(0xFFFDEB3D),
  padding: EdgeInsets.symmetric(horizontal: 10.0),
  textStyle: TextStyle(fontSize: 10.0),
);

// Define container decorations
const BoxDecoration kDrawerHeaderDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [Color(0xFF773697), Color(0xFF773697)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
);
