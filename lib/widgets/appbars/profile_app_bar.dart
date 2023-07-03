import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/detailed/person_detailed_model.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/locale_util.dart';
import 'package:movies/widgets/others/image.dart';
import 'package:movies/widgets/sections/social_medial_section.dart';

class ProfileAppBar extends SliverPersistentHeaderDelegate {
  ProfileAppBar({required this.model, required this.color, required this.controller});

  final Color color;
  final PersonDetailedModel model;
  final TabController controller;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = getAppTheme(context);
    final locale = getAppLocale(context);

    return LayoutBuilder(builder: (BuildContext layoutCtx, BoxConstraints constraints) {
      final List<Widget> children = <Widget>[];

      double height = maxExtent;
      final double opacity = maxExtent == minExtent ? 1.0 : 1 - shrinkOffset / maxExtent;

      if (constraints.maxHeight > height) {
        height = constraints.maxHeight;
      }

      children.add(Positioned(
          top: 0 - shrinkOffset / 2,
          left: 0.0,
          right: 0.0,
          height: height - 50,
          child: Container(color: color)));

      // expanded app bar
      double size = 150 - (shrinkOffset) > 80 ? 150 - (shrinkOffset) : 80;
      children.add(Align(
          alignment: Alignment.center,
          child: Opacity(
              opacity: 1 - (shrinkOffset / maxExtent * 2).clamp(0, 1.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                XImage(height: size, width: size, url: model.image, radius: 100),
                SizedBox(height: 10),
                titleBuilder(),
                SocialMediaSection(externalIds: model.externalIds)
              ]))));

      // collapsed app bar
      children.add(Align(
          alignment: Alignment.topLeft,
          child: Row(children: [
            IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white),
            Flexible(
                child: Opacity(
                    opacity: (shrinkOffset / maxExtent * 2).clamp(0, 1.0), child: titleBuilder()))
          ])));

      children.add(Positioned(bottom: -8, left: 0, right: 0, child: Divider(color: color)));

      children.add(Align(alignment: Alignment.bottomCenter, child: tabBuilder(locale)));

      return Container(
          decoration: BoxDecoration(
              color: color.withAlpha(10),
              boxShadow: <BoxShadow>[BoxShadow(color: color, blurRadius: 1, offset: Offset(0, 2))]),
          child: Stack(children: children));
    });
  }

  titleBuilder() {
    return Text(model.name,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold));
  }

  tabBuilder(locale) {
    return Container(
        color: Colors.black12,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        height: 40,
        child: TabBar(
            controller: controller,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            indicator:
                BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
            tabs:
                TypeEnum.catalogTypes().map((type) => Text(getTypeLocale(type, locale))).toList()));
  }

  @override
  double get maxExtent => 400;

  @override
  double get minExtent => kToolbarHeight + 25;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
