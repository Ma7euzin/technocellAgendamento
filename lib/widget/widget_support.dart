// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppWidget {
  static TextStyle boldTextFeildStyle() {
    return GoogleFonts.poppins(
      color: Colors.black,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    );
  }
  
  static TextStyle HeadLineTextFeildStyle() {
    return GoogleFonts.poppins(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle LightTextFeildStyle() {
    return GoogleFonts.poppins(
      color: Colors.black38,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle semiBoldTextFeildStyle() {
    return GoogleFonts.poppins(
      color: Colors.black87,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );
  }
}
