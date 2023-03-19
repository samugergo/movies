import 'package:flutter/material.dart';

class XImage extends StatefulWidget {

  final String url;

  const XImage({
    super.key,
    required this.url,
  });

  @override
  State<XImage> createState() => _XImageState();
}

class _XImageState extends State<XImage> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: SizedBox(
          width: 180,
          height: 270,
          child: widget.url != '' 
          ? Image.network(
            widget.url,
            height: 270,
            fit: BoxFit.fill,
          )
          : Image.asset(
            'assets/images/default.png',
            height: 270,
            fit: BoxFit.fill,
          )
        )
      ),
    );
  }
}