import 'package:flutter/material.dart';
import 'package:movies/models/common/cast_model.dart';
import 'package:movies/widgets/image.dart';
import 'package:movies/widgets/sections/common/section.dart';

class CastSection extends StatelessWidget {
  final List cast;

  CastSection({
    required this.cast,
  });

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Szereplők', 
      children: [
        SizedBox(
          height: 260,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: cast.map((c) => _CastMember(model: c)).toList(),
          ),
        )
      ]
    );
  }

}

class _CastMember extends StatelessWidget {
  final CastModel model;

  _CastMember({
    required this.model
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 133,
      child: Card(
        margin: EdgeInsets.only(right: 8),
        elevation: 0,
        color: Colors.white10,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.white12, 
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            XImage.customRadius(
              model.image, 
              125, 180, 
              BorderRadius.only(
                topLeft: Radius.circular(10), 
                topRight: Radius.circular(10)
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 6, right: 6),
              child: Text(
                model.name,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 12, 
                  color: Colors.white
                ),
              ),
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                model.role,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white30
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}