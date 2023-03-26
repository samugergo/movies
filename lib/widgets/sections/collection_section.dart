import 'package:flutter/material.dart';
import 'package:movies/pages/movie/collection_page.dart';
import 'package:movies/widgets/sections/common/section.dart';
import 'package:movies/models/common/collection_model.dart';

class CollectionSection extends StatelessWidget {
  CollectionSection({
    required this.model,
  });

  final CollectionModel? model;

  @override
  Widget build(BuildContext context) {
    goTo(id) {
      final Widget to = CollectionPage(id: id);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => to),
      );
    } 

    return model != null && model!.cover != ''
    ? Section(
      title: 'Gyűjtemény', 
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
                          model!.cover,
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
                  onPressed: () => goTo(model!.id),
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
                    'Gyűjtemény megtekintése',
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