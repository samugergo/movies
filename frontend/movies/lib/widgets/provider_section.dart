import 'package:flutter/material.dart';
import 'package:movies/enums/provider_enum.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/widgets/image.dart';

class ProviderSection extends StatelessWidget {

  final Providers? providers;

  ProviderSection({
    required this.providers,
  }); 

  getProvider(ProviderEnum provider) {
    if (providers == null || !providers?.isNotNullByEnum(provider)) {
      return [
        Text(
          'Nem elérhető!',
          style: TextStyle(
            color: Colors.white38,
            fontStyle: FontStyle.italic,
            fontSize: 12
          ),
        ),
      ];
    }
    return providers!.getByEnum(provider)?.map((e) => 
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: XImage(
          url: e.image, 
          width: 35, 
          height: 35
        ),
      ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ProviderEnum.values.map((e) => 
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          color: Colors.black26,
          elevation: 0,
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)
                )
            ),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.white10, width: 10),
                    ),
                  ),
                  child: Row(
                    children: [
                      ...getProvider(e),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        e.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // IntrinsicHeight(
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.stretch,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(top: 2.0),
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: Colors.white10,
          //             borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(10.0),
          //               bottomLeft: Radius.circular(10.0)
          //             ),
          //           ),
          //           child: Center(
          //             child: RotatedBox(
          //               quarterTurns: 3,
          //               child: Text(
          //                 e.title,
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 8
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 10),
          //       Center(
          //         child: Wrap(
          //           children: [
          //             ...getProvider(e),
          //           ],
          //         ),
          //       ),
          //     ]
          //   )
          // ),
        )
      ).toList(),
    );
  }
}