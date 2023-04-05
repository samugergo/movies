import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hidable/hidable.dart';
import 'package:movies/pages/search/search_page.dart';
import 'package:movies/theme/app_colors.dart';

class HidableFab extends StatelessWidget {

  final ScrollController controller;

  HidableFab({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;
    
    return Hidable(
      controller: controller,
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          backgroundColor: theme.primary,
          foregroundColor: theme.iconColor,
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