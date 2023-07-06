import 'package:flutter/material.dart';
import 'package:movies/models/common/detailed/detailed_model.dart';

import '../appbars/image_app_bar.dart';
import '../others/results/detail_card.dart';

class DetailContainer extends StatelessWidget {
  DetailContainer(
      {required this.mainColor,
      required this.coverImage,
      required this.horizontalPadding,
      required this.model,
      required this.children});

  final Color mainColor;
  final Image? coverImage;
  final double horizontalPadding;
  final DetailedModel model;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final List<Widget> paddingChildren = children
        .map((e) => Padding(padding: EdgeInsets.symmetric(horizontal: horizontalPadding), child: e))
        .toList();
    return Container(
        color: mainColor,
        child: SafeArea(
            child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverPersistentHeader(
                        pinned: true,
                        delegate: ImageAppBar(
                            title: model.title,
                            onlyTitle: false,
                            cover: coverImage,
                            color: mainColor,
                            horizontalPadding: horizontalPadding,
                            child: DetailCard(model: model)))
                  ];
                },
                body: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 1],
                            colors: [mainColor, Colors.black45])),
                    child: Scaffold(body: ListView(children: paddingChildren))))));
  }
}
