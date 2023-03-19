import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/main.dart';
import 'package:movies/widgets/button_switch.dart';
import 'package:movies/widgets/filter_sheet.dart';
import 'package:provider/provider.dart';

import '../widgets/image.dart';

class XContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();

    List list = appState.type == TypeEnum.movie ? appState.movies : appState.shows;

    show() {
      showModalBottomSheet<void>(
        context: context,
        builder: (context) => FilterSheet(),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14, top: 10),
          child: Column(
            children: [
              Text(
                appState.type.title.toUpperCase(),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              SizedBox(height: 10),
              ButtonSwitch(),
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
                      appState.order.title,
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
        ...list.map((pair) => Row(
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
            onPressed: appState.loadMore,
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