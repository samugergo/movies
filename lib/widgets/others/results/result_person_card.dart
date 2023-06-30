import 'package:flutter/material.dart';
import 'package:movies/widgets/others/results/base_card.dart';

import '../../../models/base/display_person_model.dart';

class DisplayPersonCard extends StatelessWidget {
  DisplayPersonCard({required this.model});

  final DisplayPersonModel model;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
        image: model.image,
        defaultImage: model.gender.image,
        title: model.name,
        horizontalPadding: 10,
        children: [
          if (model.knownFor != '')
            Text(model.knownFor, style: TextStyle(color: Colors.white38, fontSize: 12))
        ]);
  }
}
