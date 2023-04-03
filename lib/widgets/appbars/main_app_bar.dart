import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class MainAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: appState.type == TypeEnum.movie 
      ? Text(
        key: ValueKey(1),
        appState.type.title.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      )
      : Text(
        key: ValueKey(2),
        appState.type.title.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}