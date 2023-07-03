import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/locale_util.dart';
import 'package:movies/widgets/others/chip_list.dart';

import 'filter_sheet.dart';

class SearchSheet extends StatefulWidget {
  SearchSheet({
    required this.type,
    required this.function,
  });

  final dynamic type;
  final Function(dynamic) function;

  @override
  State<SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<SearchSheet> {
  @override
  Widget build(BuildContext context) {
    final locale = getAppLocale(context);
    final theme = getAppTheme(context);

    titlesType() {
      return TypeEnum.values.map((type) => getTypeLocale(type, locale)).toList();
    }

    return SizedBox(
        height: 150,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(locale.searchTypeTitle,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: theme.primaryTextColor)),
              SizedBox(height: 10),
              DropdownSelect(
                  icon: Icons.theaters,
                  titles: titlesType(),
                  setValue: widget.function,
                  value: widget.type,
                  values: TypeEnum.values)
            ]))));
  }
}
