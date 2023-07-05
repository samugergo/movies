import 'package:flutter/material.dart';
import 'package:movies/models/others/cast_model.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/sections/common/section.dart';

class DirectorSection extends StatelessWidget {
  DirectorSection({required this.model});

  final CastModel? model;

  @override
  Widget build(BuildContext context) {
    final locale = getAppLocale(context);
    return model != null
        ? Section(
            title: locale.director,
            children: [Text(model!.name, style: TextStyle(color: Colors.white70, fontSize: 12))])
        : SizedBox();
  }
}
