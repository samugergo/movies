import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/search/search_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/containers/gradient_container.dart';
import 'package:movies/widgets/others/image_card.dart';
<<<<<<< HEAD
import 'package:movies/widgets/sections/filter_section.dart';
=======
import 'package:movies/widgets/sections/filter/filter_section.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
>>>>>>> new-route

class CatalogPage extends StatefulWidget {
  CatalogPage({
    required this.load,
  });

  final Function load;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> with AutomaticKeepAliveClientMixin{
  late ScrollController _controller;
  bool _showBtn = false;
  double showOffset = 200;

  _setShowBtn(bool showBtn) {
    setState(() {
      _showBtn = showBtn;
    });
  }

  _controllerListener() async {
    if (_showBtn && _controller.position.pixels < showOffset) {
      _setShowBtn(false);
    }
    if (!_showBtn && _controller.position.pixels > showOffset) {
      _setShowBtn(true);
    }
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      await widget.load();
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_controllerListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = getAppState(context);
    final theme = getAppTheme(context);

    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.black.withOpacity(0.6),
        ),
        child: GradientContainer(
            child: Scaffold(
                body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _GridView(load: appState.loadCatalog, controller: _controller)),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButton: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: _showBtn ? 1.0 : 0.0,
                    child: FloatingActionButton(
                        onPressed: () {
                          _controller.animateTo(0,
                              duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        mini: true,
                        backgroundColor: theme.primary,
                        child: Icon(Icons.arrow_upward, color: Colors.white))))));
  }
  
  @override
  bool get wantKeepAlive => true;
}

class _GridView extends StatefulWidget {
  _GridView({
    required this.load,
    required this.controller,
  });

  final Function load;
  final ScrollController controller;

  @override
  State<_GridView> createState() => _GridViewState();
}

class _GridViewState extends State<_GridView> {
  @override
  Widget build(BuildContext context) {
    final appState = getAppState(context);
    final theme = getAppTheme(context);

    final itemCount = appState.grid.value;
    final list = appState.catalogList;

    final gridModel = getGridViewModel(context, itemCount);

    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
                pinned: true,
                scrolledUnderElevation: 0,
                backgroundColor: theme.primary,
                titleSpacing: 5,
                title: _SearchField())
          ];
        },
        body: ListView(controller: widget.controller, children: [
          FilterSection(),
          GridView.count(
<<<<<<< HEAD
              padding: EdgeInsets.symmetric(horizontal: 5),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: itemCount,
              mainAxisSpacing: gridModel.mainSpacing,
              crossAxisSpacing: gridModel.crossSpacing,
              childAspectRatio: gridModel.aspectRatio!,
              children: list
                  .map<Widget>((pair) => ImageCard(
                      model: pair,
                      goTo: (model) {
                        final Widget to = TypeEnum.isMovie(model.type)
                            ? MoviePage(id: model.id)
                            : ShowPage(id: model.id);
                        goTo(context, to);
                      }))
                  .toList()),
          SizedBox(height: 10)
        ]));
=======
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
                context.go('/${model.type.value}?id=${model.id}');
                // final Widget to = TypeEnum.isMovie(model.type)
                //   ? MoviePage(id: model.id, color: Colors.black) 
                //   : ShowPage(id: model.id, color: Colors.black);
                // goTo(context, to);
              },
            )).toList(),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
>>>>>>> new-route
  }
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = getAppTheme(context);
    final locale = getAppLocale(context);

    return TextField(
        textInputAction: TextInputAction.search,
        readOnly: true,
        onTap: () => goTo(context, SearchPage()),
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            filled: true,
            fillColor: theme.primaryLight,
            suffixIcon: Icon(Icons.search, color: theme.unselected!),
            hintText: locale.search,
            hintStyle: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.normal),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.only(left: 15),
            constraints: BoxConstraints(maxHeight: 40)));
  }
}
