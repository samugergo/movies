import 'package:flutter/material.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:movies/utils/common_util.dart';
import 'package:transparent_image/transparent_image.dart';

class MyImageAppBar extends SliverPersistentHeaderDelegate {
  MyImageAppBar({
    required this.title,
    required this.cover,
    required this.child,
    this.onlyTitle = true,
    this.color,
    required this.horizontalPadding,
  });

  final String title;
  final Image? cover;
  final Color? color;
  final Widget child;
  final bool onlyTitle;
  final Color textColor = Colors.white;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context).extension<AppColors>()!;

    return LayoutBuilder(
      builder: (BuildContext layoutCtx, BoxConstraints constraints) { 
        final List<Widget> children = <Widget>[];

        double height = maxExtent;
        final double opacity = maxExtent == minExtent
              ? 1.0
              : 1 - shrinkOffset / maxExtent;

        if(constraints.maxHeight > height) {
          height = constraints.maxHeight;
        }
        
        // background image
        children.add(Positioned(
          top: 0 - shrinkOffset/2,
          left: 0.0,
          right: 0.0,
          height: height - 50,
          child: Opacity(
            alwaysIncludeSemantics: true,
            opacity: opacity,
            child: _buildBackgroundCover(shrinkOffset, theme),
          ),
        ));

        // expanded data
        children.add(!onlyTitle 
          ? Positioned(
            bottom: 10,
            left: horizontalPadding,
            right: horizontalPadding,
            child: Opacity(
              opacity: opacity,
              child: child,
            )
          )
          : SizedBox()
        );

        // shade container
        children.add(Opacity(
          opacity: shrinkOffset / maxExtent,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              // border: Border.all(color: Colors.red,)
            ),
          ),
        ));

        // collapsed app bar
        children.add(Align(
          alignment: onlyTitle ? Alignment.bottomCenter : Alignment.topLeft,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: textColor,
              ),
              Flexible(
                child: Opacity(
                  opacity: onlyTitle ? 1 : shrinkOffset / maxExtent,
                  child: _buildTitle(),
                ),
              ),
            ],
          ),
        ));

        children.add(
          Positioned(
            bottom: -8,
            left: 0,
            right: 0,
            child: Divider(
              color: color,
            ),
          ));

        return Container(
          decoration: BoxDecoration(
            color: color!.withAlpha(10),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: color!,
                blurRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: children
          ),
        );
      },
    );
  }

  _buildBackgroundCover(double shrinkOffset, theme) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color!,
            Colors.transparent, 
          ],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
      child: Container(        
        decoration: cover != null
        ? BoxDecoration(
          image: DecorationImage(
            image: cover!.image,
            fit: BoxFit.cover,
          ),
        )
        : BoxDecoration(
          color: theme.primary,
        ),
      ),
    );
  }

  _buildTitle() {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.bold
      ),
    );
  }

  @override
  double get maxExtent => 400;
  
  @override
  double get minExtent => kToolbarHeight;
  
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}