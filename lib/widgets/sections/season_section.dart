import 'package:flutter/material.dart';
import 'package:movies/widgets/sections/common/section.dart';

class SeasonSection extends StatelessWidget {
  SeasonSection({
    required this.list,
  });

  final List list;

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Évadok',
      children: [
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: list.map((s) => 
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white12, width: 1),
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(Colors.white60, BlendMode.modulate),
                          child: s!.image != ''
                          ? Image.network(
                            s.image,
                            fit: BoxFit.cover,
                            width: 125,
                            height: 180,
                          )
                          : SizedBox(
                            width: 120,
                            height: 180,
                          )
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Card(
                          color: Colors.black.withAlpha(120),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(
                              color: Colors.white,
                              width: 1
                            )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            child: Text(
                              '${s.seasonNumber}. évad',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ).toList(),
          ),
        ),
      ],
    ); 
  }
}