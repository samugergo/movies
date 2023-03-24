import 'package:flutter/material.dart';
import 'package:movies/widgets/result_card.dart';

class DisplayAppBar extends StatelessWidget {
  final String title;
  final Image cover;
  final String image;
  final String release;
  final String percent;
  final double raw; 
  final List genres;

  DisplayAppBar({
    required this.title,
    required this.cover,
    required this.image,
    required this.release,
    required this.percent,
    required this.raw,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: CustomSliverDelegate(
        expandedHeight: 300,
        title: title,
        cover: cover,
        image: image,
        release: release,        
        vote: percent,
        raw: raw,
        genres: genres
      ),
    );
  }

}

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final String title;
  final Image cover;
  final String image;
  final String release;
  final String vote;
  final double raw; 
  final List genres;

  CustomSliverDelegate({
    required this.expandedHeight,
    required this.title,
    required this.cover,
    required this.image,
    required this.release,
    required this.vote,
    required this.raw,
    required this.genres,
    this.hideTitleWhenExpanded = true, 
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - shrinkOffset;
    final cardTopPosition = expandedHeight / 2 + 80 - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    return SizedBox(
      height: expandedHeight + 80,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff292A37)
        ),
        child: Stack(
          children: [
            SizedBox(
              height: appBarSize < kToolbarHeight ? kToolbarHeight : appBarSize,
              child: AppBar(
                backgroundColor: Color(0xff292A37),
                elevation: 0.0,
                scrolledUnderElevation: 0,
                leading: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                titleSpacing: 0,
                flexibleSpace: Opacity(
                  opacity: hideTitleWhenExpanded ? 0 + percent : 1.0,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black, 
                          Colors.transparent
                        ],
                      ).createShader(
                      Rect.fromLTRB(0, 0, rect.width, rect.height)
                      );
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image(
                      image: cover.image,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  ),
                ),
                title: Opacity(
                  opacity: hideTitleWhenExpanded ? 1.0 - percent : 1.0,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              top: cardTopPosition > 0 ? cardTopPosition : 0,
              bottom: 0.0,
              child: Opacity(
                opacity: percent,
                child: ResultCard(
                  image: image, 
                  title: title, 
                  release: release, 
                  percent: vote, 
                  raw: raw,
                  genres: genres,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + 80;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}