import 'package:flutter/material.dart';
import 'package:movies/utils/color_util.dart';
import 'package:movies/widgets/result_card.dart';

class MyImageAppBar extends SliverPersistentHeaderDelegate {
  MyImageAppBar({
    required this.title,
    required this.poster,
    required this.release,
    required this.percent,
    required this.raw,
    required this.genres,
    required this.cover,
    this.color = const Color(0xff292A37),
  });

  final String title;
  final String poster;
  final String release;
  final String percent;
  final double raw;
  final List genres;
  final Image? cover;
  final Color? color;

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
          top: 0,
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
        children.add(Positioned(
          top: _coverHeight - _posterHeight/2 - shrinkOffset,
          left: 10,
          right: 10,
          child: Opacity(
            opacity: opacity,
            child: _buildExpandedData(),
          ),
        ));

        // shade container
        children.add(Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: height,
          child: Opacity(
            opacity: shrinkOffset / maxExtent,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: color!, width:0),
              ),
            ),
          ),
        ));

        // collapsed app bar
        children.add(Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: textColor,
              ),
              Flexible(
                child: Opacity(
                  opacity: shrinkOffset / maxExtent,
                  child: _buildTitle(),
                ),
              ),
            ],
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
            color!,
            Colors.transparent, 
          ],
        ).createShader(rect);
      },
      blendMode: BlendMode.darken,
      child: Container(        
        decoration: BoxDecoration(
          image: DecorationImage(
            image: cover!.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
      // child: cover != null 
      // ? Image(
      //   image: cover!.image,
      //   height: _coverHeight,
      //   fit: BoxFit.cover,  
      // )
      // : SizedBox()
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

  _buildExpandedData() {
    return ResultCard(
      image: poster, 
      title: title, 
      release: release, 
      percent: percent, 
      raw: raw,
      genres: genres,
    );
  }

  @override
  double get maxExtent => 350;
  
  @override
  double get minExtent => kToolbarHeight;
  
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}