import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/models/common/person_model.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/color_util.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/containers/gradient_container.dart';
import 'package:movies/widgets/loaders/color_loader.dart';
import 'package:movies/widgets/others/image.dart';
import 'package:movies/widgets/loaders/loader.dart';
import 'package:movies/widgets/appbars/my_image_app_bar.dart';
import 'package:movies/widgets/others/image_card.dart';
import 'package:movies/widgets/sections/common/section.dart';
import 'package:movies/widgets/sections/common/section_title.dart';
import 'package:movies/widgets/states/common/image_colored_state.dart';

class PersonPage extends StatefulWidget {
  PersonPage({
    required this.id,
  });

  final int id;
  
  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends ImageColoredState<PersonPage> {  
  PersonModel? person;
  List? movieList;
  List? showList;

  // fetch methods
  _fetchMovieList() async {
    var l = await fetchPerform(widget.id, 'movie');
    setState(() {
      movieList = l;
    });
  }
  _fetchShowList() async {
    var l = await fetchPerform(widget.id, 'tv');
    setState(() {
      showList = l;
    });
  }

  @override
  void init() async { 
    mainColor = Color(0xff292A37);
    var p = await fetchPersonById(widget.id);
    setState(() {
      person = p;
    });

    _fetchMovieList();
    _fetchShowList();
    
    preloadImage(originalImageLink(p.image));
  }

  @override
  bool isLoading() {
    return person == null 
      || movieList == null
      || showList == null
      || imageLoading;
  }

  @override
  Widget build(BuildContext context) {
    goColor(id, color, type) {
      final Widget to = type == TypeEnum.movie
        ? MoviePage(id: id, color: color) 
        : ShowPage(id: id, color: color);
      goTo(context, to);
    }

    go(model, type){
      getColorFromImage(
        lowImageLink(model.cover), 
        (color) => goColor(model.id, color, type)
      );
    } 

    final double width = MediaQuery.of(context).size.width;
    const itemCount = 3;
    const crossSpacing = 10.0;
    const mainSpacing = 10.0;
    final itemWidth = width/itemCount - itemCount * crossSpacing;
    final itemHeight = itemWidth*1.5;

    return isLoading()
      ? ColorLoader(color: mainColor!)
      : Material(
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.light.copyWith(           
            statusBarColor: mainColor,
          ),
          child: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: MyImageAppBar(
                      title: person!.name, 
                      onlyTitle: true,
                      cover: coverImage,
                      color: mainColor,
                      child: Text(person!.name),
                    ),
                  ),
                ];
              },
              body: GradientContainer(
                children: [
                  Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Section(
                              title: 'Alap adatok', 
                              children: [
                                Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 0,
                                  color: Colors.black26,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Colors.white12, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              person!.birthday,
                                              style: TextStyle(
                                                color: Colors.white70
                                              ),
                                            ),
                                            Text(
                                              person!.birthPlace,
                                              style: TextStyle(
                                                color: Colors.white70
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                            ),
                            SectionTitle(
                              titleLeftPadding: 0, 
                              title: 'Filmek'
                            ),
                            GridView.count(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: itemCount,
                              mainAxisSpacing: mainSpacing,
                              crossAxisSpacing: crossSpacing,
                              childAspectRatio: itemWidth/itemHeight,
                              children: movieList!.map((pair) => ImageCard(
                                model: pair,
                                goTo: (model) {
                                  go(model, TypeEnum.movie);
                                },
                              )).toList(),
                            ),
                            SectionTitle(
                              titleLeftPadding: 0, 
                              title: 'Sorozatok & Tv'
                            ),
                            GridView.count(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: itemCount,
                              mainAxisSpacing: mainSpacing,
                              crossAxisSpacing: crossSpacing,
                              childAspectRatio: itemWidth/itemHeight,
                              children: showList!.map((pair) => ImageCard(
                                model: pair,
                                goTo: (model) {
                                  go(model, TypeEnum.show);
                                },
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),
          )
        )
      );
  }
}