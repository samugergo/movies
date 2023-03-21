import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/detailed/movie_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/widgets/image.dart';
import 'package:palette_generator/palette_generator.dart';

class MoviePage extends StatefulWidget {

  final int id;

  MoviePage({
    super.key,
    required this.id
  });

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  MovieDetailedModel? movie;
  Color? mainColor;

  init() async {
    var m = await fetchById(widget.id, TypeEnum.movie);
    ImageProvider prov = Image.network(m.cover).image;
    var c = await getImagePalette(prov);
    setState(() {
      movie = m;
      mainColor = c;
    });
  }

  Future<Color> getImagePalette (ImageProvider imageProvider) async {
  final PaletteGenerator paletteGenerator = await PaletteGenerator
      .fromImageProvider(imageProvider);
  return paletteGenerator.dominantColor!.color.withAlpha(180);
}

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: mainColor ?? Colors.black,
    ));

    return 
      movie != null 
      ? Container(
      decoration: BoxDecoration(
      //   // image: DecorationImage(
      //   //   image: NetworkImage(movie!.cover),
      //   //   alignment: Alignment.topCenter
      //   // ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 1],
          colors: [Color(0xff292A37), Color(0xff0F1018)],
          tileMode: TileMode.mirror
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(            
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Image.network(
                  movie!.cover,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    SizedBox(height: 150),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        XImage(url: movie!.image, width: 100, height: 150),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  movie!.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  movie!.release,
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Card(
                                elevation: 0,
                                color: Colors.black.withAlpha(50),
                                shape: CircleBorder(),
                                child: Stack(
                                  children: [
                                    CircularProgressIndicator(
                                      value: movie!.raw / 10,
                                      color: Color.lerp(Colors.red, Colors.green, movie!.raw / 10),
                                      strokeWidth: 2,
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          movie!.percent,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // body: 
        //   ListView(
        //     children: [
        //       SizedBox(height: 180),
        //       Text(
        //         movie!.title,
        //         style: TextStyle(
        //           color:Colors.white
        //         ),
        //       ),
        //     ],
        //   ),
      ),
    )
    : SizedBox();
  }
}