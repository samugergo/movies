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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Nem elérhető!',
            style: TextStyle(
              color: Colors.white38,
              fontStyle: FontStyle.italic,
              fontSize: 12
            ),
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
          height: 35,
          radius: 10,
        ),
      ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: providers!.available.map((e) => 
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
        )
      ).toList(),
    );
  }
}