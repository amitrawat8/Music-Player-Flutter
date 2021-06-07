import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/**
 * Created by Amit Rawat on 05-06-2021
 */

class StyleFonts {
  static TextStyle fontstyle(double fontsize, FontWeight font, Color color) {
    return GoogleFonts.lato(
      textStyle: TextStyle(
          decoration: TextDecoration.none,
          fontSize: fontsize,
          fontWeight: font,
          color: color),
    );
  }
}
