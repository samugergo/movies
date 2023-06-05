import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies/enums/order_enum.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/locale_util.dart';
import 'package:movies/widgets/sheets/filter_sheet.dart';

class FilterSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appState = getAppState(context);
    final theme = getAppTheme(context);
    final locale = getAppLocale(context);

    show() {
      showModalBottomSheet<void>(
        elevation: 0,
        context: context,
        builder: (context) => FilterSheet(),
      );
    }

    title() {
      final type = getTypeLocale(appState.type, locale).toLowerCase();
      switch (appState.order) {
        case OrderEnum.popular:
          return locale.popularType(type);
        default:      
          return locale.topRatedType(type);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.arrowDownWideShort,
            color: theme.iconColor,
            size: 14,
          ),
          SizedBox(width: 10),
          Text(
            title(),
            style: TextStyle(
              color: theme.primaryTextColor,
              fontSize: 14,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () => show(), 
            icon: Icon(
              Icons.filter_list,
              color: theme.iconColor,
            ),
          ),
        ],
      ),
    );
  }
}