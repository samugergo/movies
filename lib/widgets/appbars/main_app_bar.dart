import 'package:flutter/material.dart';
import 'package:movies/pages/search/search_page.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/navigation_util.dart';

class MainAppBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = getAppTheme(context);
    final locale = getAppLocale(context);

    return LayoutBuilder(
      builder: (BuildContext layoutCtx, BoxConstraints constraints) { 
        final List<Widget> children = <Widget>[];
        
        double height = maxExtent;
        final double opacity = maxExtent == minExtent
              ? 1.0
              : (1.0 - (shrinkOffset / maxExtent)*1.5).clamp(0, 1.0);

        if(constraints.maxHeight > height) {
          height = constraints.maxHeight;
        }

        children.add(
          Positioned(
            top: 0,
            right: 0,
            child: Opacity(
              alwaysIncludeSemantics: true,
              opacity: opacity,
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          )
        );

        children.add(
          Align(
            alignment: Alignment.center,
            child: Opacity(
              alwaysIncludeSemantics: true,
              opacity: opacity,
              child: Text(
                locale.catalog,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white
                ),
              ),
            ),
          )
        );

        // children.add(
        //   Positioned(
        //     // alignment: Alignment.bottomLeft,
        //     bottom: 8,
        //     left: 5,
        //     right: 5,
        //     child: _buildTextField(theme, locale, context),
        //   ),
        // );

        return Container(
          color: theme.primary,
          child: Stack(
            children: children,
          ),
        );
      }
    ); 
  }

  @override
  double get maxExtent => 200;
  
  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;

}