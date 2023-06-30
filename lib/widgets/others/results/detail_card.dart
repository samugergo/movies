import 'package:flutter/material.dart';
import 'package:movies/models/common/detailed/detailed_model.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/others/results/base_card.dart';

class DetailCard extends StatelessWidget {
  final DetailedModel model;

  DetailCard({required this.model});

  @override
  Widget build(BuildContext context) {
    final locale = getAppLocale(context);

    final List list = model.genres.length > 3 ? model.genres.sublist(0, 3) : model.genres;
    return BaseCard(
        image: model.image,
        title: model.title,
        space: 8,
        titleBottom: 8,
        horizontalPadding: 8,
        children: [
          Wrap(children: list.map((genre) => genreBuilder(genre)).toList()),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Row(children: [
              Text(timeFormat(model.length, locale),
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              SizedBox(width: 20),
              Text(year(model.release), style: TextStyle(color: Colors.white70, fontSize: 12))
            ]),
          ),
          Row(children: [
            Icon(Icons.star_rate, color: Colors.yellow, size: 15),
            SizedBox(width: 5),
            Text(model.raw.toStringAsFixed(1), style: TextStyle(color: Colors.white, fontSize: 12))
          ])
        ]);
  }

  Widget genreBuilder(String genre) {
    return Card(
        margin: EdgeInsets.only(right: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 0,
        color: Colors.white24,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(genre, style: TextStyle(fontSize: 12, color: Colors.white70))));
  }
}
