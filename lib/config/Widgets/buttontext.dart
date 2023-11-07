import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types
class buttontext extends StatelessWidget {
  final String text;
  final bool isChosen;
  const buttontext({super.key, required this.text, required this.isChosen});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: isChosen ? FontWeight.w800 : FontWeight.w400,
          fontStyle: FontStyle.normal,
          color: Colors.white),
    );
  }
}
