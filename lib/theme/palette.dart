import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Palette {
  static const Color primaryColor = Color(0xFFeb5757);
  static const Color backgroundColor = Color(0xFFF4F3F8);
  static const Color textColor = Color(0xFF2f3447);
  static const Color drawerColor = Color(0xFF1B1F2B);

  // ligth theme
  final ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: backgroundColor,
    textTheme: GoogleFonts.interTextTheme().apply(),
    primaryColor: primaryColor,
  );
}
