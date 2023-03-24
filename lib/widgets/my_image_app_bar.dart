import 'package:flutter/material.dart';
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
  });

  final String title;
  final String poster;
  final String release;
  final String percent;
  final double raw;
  final List genres;
  final Image cover;


  double? _topPadding;
  final double _coverHeight = 270;
  final double _posterHeight = 150;
  final Color _background = Color(0xff292A37);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    _topPadding ??= MediaQuery.of(context).padding.top;
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
                color: _background,
                border: Border.all(color: _background, width:0),
              ),
            ),
          ),
        ));

        // collapsed app bar
        children.add(Positioned(
          left: 0,
          right: 10,
          top: 6,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
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

        return ClipRect(
          child: Container(
            decoration: BoxDecoration(
              color: _background,
              border: Border.all(color: _background, width:0),
            ),
            child: Stack(
              children: children
            ),
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
            _background, 
            Colors.transparent
          ],
        ).createShader(
          Rect.fromLTRB(0, 0, rect.width, rect.height)
        );
      },
      blendMode: BlendMode.dstIn,
      child: Image(
        image: cover.image,
        height: _coverHeight,
        fit: BoxFit.cover,
      )
    );
  }

  _buildTitle() {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
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