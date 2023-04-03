import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradientContainer extends StatelessWidget {

  final Widget child;

  GradientContainer({
    required this.child
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
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(           
          statusBarColor: Color(0xff292A37),
        ),
        child: SafeArea(
          child: child,
        )
      ),
    );
  }
}