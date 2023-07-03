import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/models/detailed/person_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/common_util.dart';
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

  List allMovies = [];
  List allShows = [];

  init() async {
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

  bool isLoading() {
    return model == null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = getAppTheme(context);

    return XAnimatedContainer(
        color: Color(0xff0b1323),
        duration: 300,
        statusbar: isLoading() ? theme.primary : Color(0xff0b1323),
        child: isLoading()
            ? ColorLoader(color: theme.primary!)
            : Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 1],
                        colors: [Color(0xff0b1323), Colors.black45])),
                child: SafeArea(
                    child: NestedScrollView(
                        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                          return [
                            SliverPersistentHeader(
                                pinned: true,
                                delegate: ProfileAppBar(
                                    color: Color(0xff0b1323),
                                    model: model!,
                                    controller: tabController))
                          ];
                        },
                        body: Column(children: <Widget>[
                          Expanded(child: TabBarView(controller: tabController, children: [
                            tabBuilder(context, allMovies),
                            tabBuilder(context, allShows),
                          ]))
                        ])))));
  }

  Widget tabBuilder(BuildContext context, List list) {
    final gridModel = getGridViewModel(context, 3);

    return GridView.count(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
            .toList());
  }
}
