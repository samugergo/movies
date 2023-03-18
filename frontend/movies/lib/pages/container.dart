import 'package:flutter/material.dart';
import 'package:movies/widgets/button_switch.dart';

import '../widgets/image.dart';

class XContainer extends StatefulWidget {

  final int type;
  final Function updateType;
  final List<dynamic> list;

  XContainer({
    super.key,
    required this.type,
    required this.updateType,
    required this.list,
  });

  @override
  State<XContainer> createState() => _ContainerState();
}

class _ContainerState extends State<XContainer> {
  
  final List items = [
    'Filmek', 'Sorozatok'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Text(
                items[widget.type].toUpperCase(),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              SizedBox(height: 10),
              ButtonSwitch(
                items: items,
                active: widget.type,
                onPressed: widget.updateType,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        ...widget.list.map((pair) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            pair[0] != null 
            ? XImage(url: pair[0].image)
            : SizedBox(),
            pair[1] != null 
            ? XImage(url: pair[1].image)
            : SizedBox(),
          ]
        )).toList(),
        // ElevatedButton(
        //   onPressed: _fetchMovies, 
        //   child: Text('Több betöltése'),
        // )
      ]
    );
  }
}