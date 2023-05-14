import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/state.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/others/image_card.dart';
import 'package:provider/provider.dart';

class CatalogPage extends StatelessWidget {
  CatalogPage({
    required this.scrollController
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(           
        statusBarColor: Colors.black
        .withOpacity(0.6),
      ),
      child: Scaffold(
        body: _GridView(
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _GridView extends StatefulWidget {
  _GridView({
    required this.scrollController
  });

  final ScrollController scrollController;

  @override
  State<_GridView> createState() => _GridViewState();
}

class _GridViewState extends State<_GridView> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final itemCount = appState.itemCount;
    final list = appState.catalogList;
    
    final double width = MediaQuery.of(context).size.width;
    const crossSpacing = 10.0;
    const mainSpacing = 10.0;
    final itemWidth = width/itemCount - itemCount * crossSpacing;
    final itemHeight = itemWidth*1.5;

    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Column(
        children: [
          GridView.count(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: itemCount,
            mainAxisSpacing: mainSpacing,
            crossAxisSpacing: crossSpacing,
            childAspectRatio: itemWidth/itemHeight,
            children: list.map<Widget>((pair) => ImageCard(
              model: pair,
              goTo: (model) {
                final Widget to = TypeEnum.isMovie(model.type)
                  ? MoviePage(id: model.id, color: Colors.black) 
                  : ShowPage(id: model.id, color: Colors.black);
                goTo(context, to);
              },
            )).toList(),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}