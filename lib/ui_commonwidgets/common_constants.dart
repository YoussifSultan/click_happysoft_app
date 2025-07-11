import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0074B3); // Blue
  static const Color secondary = Color(0xFF4FADE4); // Green
  static const Color dark = Color(0xFF004164); // Red
  static const Color light = Color(0xFFBAE6FF); // Light background
  static const Color gray = Color(0xFF343A40); // Dark text
  static const Color black = Color.fromARGB(255, 0, 0, 0); // Dark text
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;
}

class AppSpacing {
  // Vertical spacing
  static const SizedBox v4 = SizedBox(height: 4);
  static const SizedBox v8 = SizedBox(height: 8);
  static const SizedBox v16 = SizedBox(height: 16);
  static const SizedBox v24 = SizedBox(height: 24);

  // Horizontal spacing
  static const SizedBox h4 = SizedBox(width: 4);
  static const SizedBox h8 = SizedBox(width: 8);
  static const SizedBox h16 = SizedBox(width: 16);
}
