import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/models/common/person_model.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/containers/gradient_container.dart';
import 'package:movies/widgets/image.dart';
import 'package:movies/widgets/loader.dart';
import 'package:movies/widgets/my_image_app_bar.dart';
import 'package:movies/widgets/sections/common/section.dart';
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

    // preloadImageWithColor(lowImageLink(p.image));
    preloadImage(originalImageLink(p.image));
  }

  @override
  bool isLoading() {
    return person == null 
      || mainColor == null
      || movieList == null
      || showList == null
      || imageLoading;
  }

  @override
  Widget build(BuildContext context) {
    goTo(id, type) {
      final Widget to = type == 'movie' ? MoviePage(id: id) : ShowPage(id: id);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => to),
      );
    } 

    return isLoading()
      ? Loader()
      : Material(
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.light.copyWith(           
            statusBarColor: mainColor ?? Color(0xff292A37),
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
                    body: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Section(
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
                        ),
                        Section(
                          title: 'Filmek',
                          titleLeftPadding: 15,
                          children: [
                            ...chunkList(movieList).map((pair) => _ImageRow(
                              pair: pair,
                              goTo: goTo,
                              type: 'movie'
                            )).toList(),
                          ],
                        ),
                        Section(
                          title: 'Sorozatok & Tv',
                          titleLeftPadding: 15,
                          children: [
                            ...chunkList(showList).map((pair) => _ImageRow(
                              pair: pair,
                              goTo: goTo,
                              type: 'show'
                            )).toList(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        )
      );
  }
}

class _ImageRow extends StatelessWidget {
  final List pair; 
  final Function goTo;
  final String type;

  _ImageRow({
    required this.pair,
    required this.goTo,
    required this.type
  });

  final double _padding = 20;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width/2 - _padding;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: pair.isNotEmpty 
          ? _ImageCard(model: pair[0], goTo: goTo, width: width, type: 'movie')
          : SizedBox(),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: pair.length > 1 
          ? _ImageCard(model: pair[1], goTo: goTo, width: width, type: 'tv')
          : SizedBox(width: width),
        ),
      ],
    );
  }

}

class _ImageCard extends StatelessWidget {
  final DisplayModel model;
  final Function goTo;
  final double width;
  final String type;

  _ImageCard({
    required this.model,
    required this.goTo,
    required this.width,
    required this.type
  });

  final double _padding = 20;

  @override
  Widget build(BuildContext context) {    
    double width = MediaQuery.of(context).size.width/2 - _padding;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => goTo(model.id, type),
        child: XImage.custom(
          model.image,
          width
        ),
      ),
    );
  }
}