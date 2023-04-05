import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class XAnimatedContainer extends StatelessWidget {
  XAnimatedContainer({
    required this.color,
    required this.duration,
    required this.child,
  });

  final Color color;
  final int duration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(           
          statusBarColor: color,
        ),
        child: Container(
          color: color,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: duration),
            child: child,
          ),
        ),
      )
    );
  }

}