import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/detailed/show_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/widgets/image.dart';

class ShowPage extends StatefulWidget {

  final int id;

  ShowPage({
    super.key,
    required this.id
  });

  @override
  State<ShowPage> createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  ShowDetailedModel? show;

  init() async {
    var s = await fetchById(widget.id, TypeEnum.show);
    setState(() {
      show = s;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    return 
      show != null 
      ? Container(
      decoration: BoxDecoration(
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
                  show!.cover,
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
                        XImage(url: show!.image, width: 100, height: 150),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  show!.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  show!.release,
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
                                      value: show!.raw / 10,
                                      color: Color.lerp(Colors.red, Colors.green, show!.raw / 10),
                                      strokeWidth: 2,
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          show!.percent,
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
      ),
    )
    : SizedBox();
  }
}