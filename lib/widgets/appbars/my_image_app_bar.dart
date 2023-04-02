import 'package:flutter/material.dart';

class MyImageAppBar extends SliverPersistentHeaderDelegate {
  MyImageAppBar({
    required this.title,
    required this.cover,
    required this.child,
    this.onlyTitle = true,
    this.color = const Color(0xff292A37),
  });

  final String title;
  final Image? cover;
  final Color? color;
  final Widget child;
  final bool onlyTitle;

  final double _coverHeight = 270;
  final double _posterHeight = 150;
  final Color textColor = Colors.white;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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
          height: height,
          child: Opacity(
            alwaysIncludeSemantics: true,
            opacity: opacity,
            child: _buildBackgroundCover(shrinkOffset),
          ),
        ));

        // expanded data
        children.add(!onlyTitle 
          ? Positioned(
            bottom: 10,
            left: 10,
            right: 10,
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
            child: Opacity(
              opacity: shrinkOffset/maxExtent,
              child: Divider(
                color: Colors.white,
              ),
            ),
          ));

        return Container(
          decoration: BoxDecoration(
            color: color,
          ),
          child: Stack(
            children: children
          ),
        );
      },
    );
  }

  _buildBackgroundCover(double shrinkOffset) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent, 
            color!
          ],
        ).createShader(rect);
      },
      blendMode: BlendMode.srcOver,
      child: Container(        
        decoration: cover != null
        ? BoxDecoration(
          image: DecorationImage(
            image: cover!.image,
            fit: BoxFit.cover,
          ),
        )
        : BoxDecoration(
          color: Color(0xff292A37),
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