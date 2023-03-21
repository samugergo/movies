import 'package:flutter/material.dart';
import 'package:movies/widgets/image.dart';

class ResultCard extends StatelessWidget {

  final String image;
  final String title;
  final String release;
  final String percent;
  final double raw;

  ResultCard({
    required this.image,
    required this.title,
    required this.release,
    required this.percent,
    required this.raw
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        XImage(
          url: image, 
          width: 100, 
          height: 150
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  release,
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Card(
                  elevation: 0,
                  color: Colors.black.withAlpha(50),
                  shape: CircleBorder(),
                  child: Stack(
                    children: [
                      CircularProgressIndicator(
                        value: raw / 10,
                        color: Color.lerp(Colors.red, Colors.green, raw / 10),
                        strokeWidth: 2,
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            percent,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}