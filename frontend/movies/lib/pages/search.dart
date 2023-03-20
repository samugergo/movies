import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff292A37),
    ));
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.5, 1],
          colors: [Color(0xff292A37), Color(0xff0F1018)],
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Text(
            'Keresés',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30
            ),
          ),
        )
      ),
    );
  }
}