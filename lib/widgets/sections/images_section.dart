import 'package:flutter/material.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/others/image.dart';
import 'package:movies/widgets/sections/common/section.dart';

class ImagesSection extends StatelessWidget {
  ImagesSection({
    required this.images,
  });

  List images;

  @override
  Widget build(BuildContext context) {
    return images.isEmpty 
    ? SizedBox()
    : Section(
      title: 'Images', 
      children: [
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: images.map((e) => 
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: XImage(
                  url: imageLink(e),
                  radius: 10,
                  width: 180,
                  height: 100,
                ),
              )
            ).toList(),
          ),
        )
      ]
    );
  }
}