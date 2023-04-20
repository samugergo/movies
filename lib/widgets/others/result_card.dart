import 'package:flutter/material.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/others/image.dart';

// ignore: must_be_immutable
class ResultCard extends StatelessWidget {

  final String image;
  final String title;
  final String release;
  final double percent;
  List? genres;

  ResultCard({
    required this.image,
    required this.title,
    required this.release,
    required this.percent,
    this.genres,
  });

  @override
  Widget build(BuildContext context) {
    final List? list = genres != null && genres!.length > 3 ? genres!.sublist(0,3) : genres;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        XImage(
          url: image, 
          width: 100, 
          height: 150,
          radius: 10,
        ),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  dateFormat(release),
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rate,
                      color: Colors.yellow,
                      size: 15,
                    ),
                    SizedBox(width: 5),
                    Text(
                      percent.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Wrap(
                  children: 
                    genres != null 
                    ? list!.map((e) => 
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                        color: Colors.white38,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87
                            ),
                          ),
                        ),
                      ),
                    ).toList()
                  : [SizedBox()]
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}