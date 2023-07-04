import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/models/detailed/person_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/locale_util.dart';
import 'package:movies/widgets/appbars/profile_app_bar.dart';
import 'package:movies/widgets/containers/animated_contaner.dart';

import '../../utils/navigation_util.dart';
import '../../widgets/loaders/color_loader.dart';
import '../../widgets/others/image_card.dart';
import '../movie/movie_page.dart';
import '../show/show_page.dart';

class PersonPage extends StatefulWidget {
  PersonPage({required this.id});

  final int id;

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> with SingleTickerProviderStateMixin {
  PersonDetailedModel? model;
  late TabController tabController;

  List? allMovies;
  List? allShows;

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
  }

  init() async {
    _controller = ScrollController();
    _controller.addListener(_controllerListener);

    tabController = TabController(length: TypeEnum.catalogTypes().length, vsync: this);
    final p = await fetchPerson(widget.id);
    setState(() {
      model = p;
    });
    fetchMovies();
    fetchShows();
  }

  fetchMovies() async {
    final movies = await fetchPerform(model!.id, TypeEnum.movie);
    movies.sort();
    setState(() {
      allMovies = List.from(movies.reversed);
    });
  }

  fetchShows() async {
    final shows = await fetchPerform(model!.id, TypeEnum.show);
    shows.sort();
    setState(() {
      allShows = List.from(shows.reversed);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _controller.dispose();
    tabController.dispose();
    super.dispose();
  }

  bool isLoading() {
    return model == null || allMovies == null || allShows == null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = getAppTheme(context);
    final locale = getAppLocale(context);

    return XAnimatedContainer(
        color: theme.primary!,
        duration: 300,
        statusbar: theme.primary,
        child: isLoading()
            ? ColorLoader(color: theme.primary!)
            : Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 1],
                        colors: [theme.primary!, Colors.black45])),
                child: SafeArea(
                    child: Scaffold(
                        body: NestedScrollView(
                            controller: _controller,
                            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                              return [
                                SliverPersistentHeader(
                                    pinned: true,
                                    delegate: ProfileAppBar(
                                        color: theme.primary!,
                                        model: model!,
                                        controller: tabController))
                              ];
                            },
                            body: Column(children: <Widget>[
                              Expanded(
                                  child: TabBarView(controller: tabController, children: [
                                tabBuilder(context, allMovies!, TypeEnum.movie, locale),
                                tabBuilder(context, allShows!, TypeEnum.show, locale)
                              ]))
                            ])),
                        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                        floatingActionButton: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: _showBtn ? 1.0 : 0.0,
                            child: FloatingActionButton(
                                onPressed: () {
                                  _controller.animateTo(0,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.fastOutSlowIn);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                mini: true,
                                backgroundColor: theme.primary,
                                child: Icon(Icons.arrow_upward, color: Colors.white)))))));
  }

  Widget tabBuilder(BuildContext context, List list, TypeEnum type, locale) {
    final gridModel = getGridViewModel(context, 3);

    return list.isNotEmpty
        ? GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            shrinkWrap: true,
            crossAxisCount: 3,
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
                .toList())
        : Center(
            child: Text(locale.noData(getTypeLocale(type, locale).toLowerCase()),
                style: TextStyle(color: Colors.white, fontSize: 18)));
  }
}
