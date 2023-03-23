import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class MainAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();

    return  Text(
      appState.type.title.toUpperCase(),
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}