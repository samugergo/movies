import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/models/detailed/show_detailed_model.dart';
import 'package:movies/services/service.dart';
import 'package:movies/widgets/containers/image_gradient_container.dart';
import 'package:movies/widgets/image.dart';
import 'package:movies/widgets/result_card.dart';

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
  Providers? providers;
  
  init() async {
    var s = await fetchById(widget.id, TypeEnum.show);
    var p = await fetchProviders(widget.id, TypeEnum.show);
    setState(() {
      show = s;
      providers = p;
    });
  }

    getProvider() {
    if (providers == null || providers!.streaming == null) {
      return [];
    }
    return providers!.streaming?.map((e) => 
      Column(
        children: [
          XImage(
            url: e.image, 
            width: 50, 
            height: 50
          ),
          Text(
            e.title,
            style: TextStyle(
              color: Colors.white
            ),
          )
        ],
      )
    );
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
      ? ImageGradientContainer(
      image: show!.cover,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ListView(
              children: [
                SizedBox(height: 150),
                ResultCard(
                  image: show!.image, 
                  title: show!.title, 
                  release: show!.release, 
                  percent: show!.percent, 
                  raw: show!.raw
                ),
                ...getProvider(),
              ],
            ),
          ),
        ),
      ],
    )
    : SizedBox();
  }
}