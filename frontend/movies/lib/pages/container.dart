import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies/widgets/button_switch.dart';
import 'package:movies/widgets/filter_sheet.dart';

import '../widgets/image.dart';

class XContainer extends StatefulWidget {

  final int type;
  final int order;
  final Function updateType;
  final Function updateOrder;
  final Function loadMore;
  final List<dynamic> list;

  XContainer({
    super.key,
    required this.type,
    required this.order,
    required this.updateOrder,
    required this.updateType,
    required this.loadMore,
    required this.list,
  });

  @override
  State<XContainer> createState() => _ContainerState();
}

class _ContainerState extends State<XContainer> {
  
  final List types = [
    'Filmek', 'Sorozatok'
  ];

  final List orders = [
    'Legnépszereűbb', 'Legjobbra értékelt'
  ];

  show() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => FilterSheet(
        order: widget.order,
        updateOrder: widget.updateOrder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14, top: 10),
          child: Column(
            children: [
              Text(
                types[widget.type].toUpperCase(),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              SizedBox(height: 10),
              ButtonSwitch(
                items: types,
                active: widget.type,
                onPressed: widget.updateType,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.arrowDownWideShort,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 10),
                    Text(
                      orders[widget.order],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => show(), 
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.white,
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
          padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
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