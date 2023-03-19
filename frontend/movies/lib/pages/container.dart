import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies/widgets/button_switch.dart';

import '../widgets/image.dart';

class XContainer extends StatefulWidget {

  final int type;
  final Function updateType;
  final Function loadMore;
  final List<dynamic> list;

  XContainer({
    super.key,
    required this.type,
    required this.updateType,
    required this.loadMore,
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
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
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
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.arrowDownShortWide,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Legnépszerűbbek',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
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
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: ElevatedButton.icon(
            onPressed: () => widget.loadMore(widget.type), 
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xff343643)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            icon: FaIcon(FontAwesomeIcons.arrowRotateRight),
            label: Text('Több betöltése'),
          ),
        )
      ]
    );
  }
}