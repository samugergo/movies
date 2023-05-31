import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.titleLeftPadding,
    required this.title,
    this.centerTitle = false,
  });

  final double titleLeftPadding;
  final String title;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: titleLeftPadding, bottom: 8.0, top: 16),
      child: centerTitle 
      ? Center(
        child: Text(
          title,
          style: GoogleFonts.publicSans(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          )
        ),
      )
      : Text(
          title,
          style: GoogleFonts.publicSans(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          )
        ),
    );
  }
}