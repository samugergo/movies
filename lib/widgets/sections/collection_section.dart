import 'package:flutter/material.dart';
import 'package:movies/pages/movie/collection_page.dart';
import 'package:movies/utils/color_util.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/sections/common/section.dart';
import 'package:movies/models/others/collection_model.dart';

class CollectionSection extends StatelessWidget {
  CollectionSection({
    required this.model,
  });

  final CollectionModel? model;

  @override
  Widget build(BuildContext context) {
    final locale = getAppLocale(context);

    goColor(id, color) {
      final Widget to = CollectionPage(id: id, color: color);
      goTo(context, to);
    }

    go(model){
      getColorFromImage(
        lowImageLink(model.cover), 
        (color) => goColor(model.id, color)
      );
    } 

    return model != null && model!.cover != ''
    ? Section(
      title: locale.collection, 
      children: [
        Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white12, width: 1),
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(Colors.white60, BlendMode.modulate),
                        child: model!.cover != ''
                        ? Image.network(
                          originalImageLink(model!.cover),
                          fit: BoxFit.cover,
                          height: 180,
                        )
                        : SizedBox(height: 180)
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => go(model),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.black.withAlpha(120),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 20),
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: Colors.white,
                          width: 1
                        )
                      ),
                    ),
                  ),
                  child: Text(
                    locale.viewCollection,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ]
    )
    : SizedBox();
  }

}