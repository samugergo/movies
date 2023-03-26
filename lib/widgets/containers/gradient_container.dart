import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {

  final List<Widget> children;

  GradientContainer({
    required this.children
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 1],
          colors: [
            Color(0xff292A37), 
            Color(0xff0F1018)
          ],
          tileMode: TileMode.mirror
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(            
            children: children,
          )
        )
      )
    );
  }

}