import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:page_transition/page_transition.dart';

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