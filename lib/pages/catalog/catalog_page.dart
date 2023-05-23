import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/search/search_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/state.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/buttons/load_button.dart';
import 'package:movies/widgets/others/image_card.dart';
import 'package:movies/widgets/sections/filter/filter_section.dart';
import 'package:provider/provider.dart';

class CatalogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(           
        statusBarColor: Colors.black
        .withOpacity(0.6),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _GridView(),
        ),
      ),
    );
  }
}

class _GridView extends StatefulWidget {
  @override
  State<_GridView> createState() => _GridViewState();
}

class _GridViewState extends State<_GridView> { 
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = getAppTheme(context);
    final itemCount = appState.itemCount;
    final list = appState.catalogList;
    
    final double width = MediaQuery.of(context).size.width;
    const crossSpacing = 10.0;
    const mainSpacing = 10.0;
    final itemWidth = width/itemCount - itemCount * crossSpacing;
    final itemHeight = itemWidth*1.5;

    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) { 
        return [
          SliverAppBar(
            backgroundColor: theme.hidable,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.only(bottom: 50),
              title: Text(
                'Katalógus',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          ),
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.hidable,
            titleSpacing: 5,
            title: _SearchField(),
          )
        ];
      },
      body: ListView(
        children: [
          FilterSection(),
          GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 5),
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
          LoadButton(load: appState.loadCatalog),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = getAppState(context);
    final theme = getAppTheme(context);

    return TextField(
      textInputAction: TextInputAction.search,
      readOnly: true,
      onTap: () => goTo(context, SearchPage()),
      style: TextStyle(
        color: Colors.white
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xff222222),
        suffixIcon: Icon(
          Icons.search,
          color: theme.unselected!,
        ),
        hintText: 'Keresés',
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.normal
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.only(left: 15),
        constraints: BoxConstraints(
          maxHeight: 50,
        )
      ),
    );
  }
}