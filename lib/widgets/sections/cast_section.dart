import 'package:flutter/material.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/sections/common/section.dart';

class CastSection extends StatelessWidget {
  CastSection({
    required List cast,
  }) : _cast = cast;

  final List _cast;

  getList() {
    final l = [];
    for (var cast in _cast) {
      l.add(cast.name);
      l.add(cast.role != null && cast.role != "" ? cast.role : null);
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    final locale = getAppLocale(context);

    final double width = MediaQuery.of(context).size.width;
    const crossSpacing = 10.0;
    const mainSpacing = 2.0;
    final itemWidth = width / 2 - 2 * crossSpacing;
    const itemHeight = 17;

    return _cast.isEmpty
        ? SizedBox()
        : Section(title: locale.cast, children: [
            GridView.count(
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: mainSpacing,
                crossAxisSpacing: crossSpacing,
                childAspectRatio: itemWidth / itemHeight,
                children: getList()
                    .map<Widget>((cast) => cast != null
                        ? Text(cast, style: TextStyle(color: Colors.white70, fontSize: 12))
                        : SizedBox())
                    .toList())
          ]);
  }
}
