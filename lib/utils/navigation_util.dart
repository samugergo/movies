import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void goTo(BuildContext context, Widget to) {
  Navigator.push(
    // context,
    // CupertinoPageRoute(builder: (builder) => WillPopScope(onWillPop: () async => true, child: to))
    context,
    PageTransition(
      type: PageTransitionType.fade,
      child: to,
      duration: Duration(milliseconds: 200),
    ),
  );
}