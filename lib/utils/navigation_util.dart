import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

/// This function is the default implementation for the routing. This should be used
/// when you need to move to a different page.
/// 
/// [BuildContext] is the context of the build function.
/// [Widget] is the new page you want to go to.
void goTo(BuildContext context, Widget to) {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.fade,
      child: to,
      duration: Duration(milliseconds: 200),
    ),
  );
}