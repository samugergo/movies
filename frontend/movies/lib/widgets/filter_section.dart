import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies/main.dart';
import 'package:movies/widgets/filter_sheet.dart';
import 'package:provider/provider.dart';

class FilterSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();

    show() {
      showModalBottomSheet<void>(
        context: context,
        builder: (context) => FilterSheet(),
      );
    }

    return Padding(
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
    );
  }

}