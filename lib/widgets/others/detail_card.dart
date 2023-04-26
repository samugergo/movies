import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/models/detailed/detailed_model.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/others/image.dart';

// ignore: must_be_immutable
class DetailCard extends StatelessWidget {

  final DetailedModel? model;

  DetailCard({
    required this.model
  });

  @override
  Widget build(BuildContext context) {
    final List list = model!.genres.length > 3 ? model!.genres.sublist(0,3) : model!.genres;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        XImage(
          url: model!.image, 
          width: 100, 
          height: 150,
          radius: 10,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  model!.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.bebasNeue(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 8.0),
              //   child: Text(
              //     release,
              //     style: TextStyle(
              //       color: Colors.white38,
              //       fontSize: 12
              //     ),
              //   ),
              // ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Wrap(
                  children: 
                    list.map((e) => 
                      Card(
                        margin: EdgeInsets.only(right: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                        color: Colors.white24,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70
                            ),
                          ),
                        ),
                      ),
                    ).toList(),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    Text(
                      timeFormat(model!.length),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      year(model!.release),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.only(left: 8.0),
              //   child: Card(
              //     elevation: 0,
              //     color: Colors.black.withAlpha(50),
              //     shape: CircleBorder(),
              //     child: Stack(
              //       children: [
              //         CircularProgressIndicator(
              //           value: model!.raw / 10,
              //           color: Color.lerp(Colors.red, Colors.green, model!.raw / 10),
              //           strokeWidth: 2,
              //         ),
              //         Positioned.fill(
              //           child: Align(
              //             alignment: Alignment.center,
              //             child: Text(
              //               model!.raw.toStringAsFixed(1),
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 12
              //               ),
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
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
                      model!.raw.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}