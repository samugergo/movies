import 'package:flutter/material.dart';

class ImageGradientContainer extends StatelessWidget {

  final String image;
  final List<Widget> children;

  ImageGradientContainer({
    required this.image,
    required this.children
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 1],
          colors: [
            Color(0xff292A37), 
            Color(0xff0F1018)
          ],
          tileMode: TileMode.mirror
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(            
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black, 
                      Colors.transparent
                    ],
                  ).createShader(
                    Rect.fromLTRB(0, 0, rect.width, rect.height)
                  );
                },
                blendMode: BlendMode.dstIn,
                child: Image.network(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
              ...children,
            ],
          )
        )
      )
    );
  }

}