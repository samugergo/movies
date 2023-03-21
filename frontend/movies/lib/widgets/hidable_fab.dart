import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hidable/hidable.dart';
import 'package:movies/pages/search.dart';

class HidableFab extends StatelessWidget {

  final ScrollController controller;

  HidableFab({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Hidable(
      controller: controller,
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          backgroundColor: Color(0xff292A37),
          foregroundColor: Colors.white,
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Search()),
            )
          },
          child: Icon(
            FontAwesomeIcons.magnifyingGlass,
          ),
        ),
      ),
    );
  }
}