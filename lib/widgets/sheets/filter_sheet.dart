import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies/enums/grid_enum.dart';
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:movies/states/state.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/locale_util.dart';
import 'package:movies/widgets/others/chip_list.dart';

class FilterSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appState = getAppState(context);
    final theme = getAppTheme(context);
    final locale = getAppLocale(context);

    groupTitle(String groupTitle) {
      return Text(
        groupTitle,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.primaryTextColor
        ),
      );
    }

    titlesType() {
      return TypeEnum.values.map((type) => getTypeLocale(type, locale)).toList();
    }

    titlesOrder() {
      return OrderEnum.orders().map((order) => getOrderLocale(order, locale)).toList();
    }

    return SizedBox(
      height: 350,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            groupTitle(locale.filterAndSort),
            SizedBox(height: 20),
            DropdownSelect(
              icon: Icons.theaters,
              titles: titlesType(),
              setValue: appState.setType,
              value: appState.type,
              values: TypeEnum.values,
            ),
            SizedBox(height: 12),
            groupTitle(locale.order),
            SizedBox(height: 10),
            DropdownSelect(
              icon: Icons.star_rate,
              titles: titlesOrder(),
              setValue: appState.setOrder,
              value: appState.order,
              values: OrderEnum.orders(),
            ),
            SizedBox(height: 12),
            groupTitle(locale.layout),
            SizedBox(height: 10),
            DropdownSelect(
              icon: Icons.apps,
              value: appState.grid, 
              values: GridEnum.values, 
              titles: GridEnum.titles(), 
              setValue: appState.setGrid
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownSelect<T> extends StatelessWidget {
  const DropdownSelect({
    super.key,
    required this.value,
    required this.values,
    required this.setValue,
    required this.titles,
    this.icon,
  });

  final List<String> titles;
  final Function(T?) setValue;
  final List<T> values;
  final T value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = getAppTheme(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.primaryLight,
        borderRadius: BorderRadius.circular(50),
      ),
  
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: DropdownButtonFormField(
          dropdownColor: theme.primaryLight,
          value: value,
          items: titles.asMap().entries.map((entry) => 
              DropdownMenuItem(
                value: values[entry.key],
                child: Text(entry.value),
              )
            ).toList(),
          onChanged: setValue,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),
          decoration: InputDecoration(
            prefixIcon: icon != null 
            ? Icon(icon) 
            : SizedBox(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)
            ),
          ),
        ),
      ),
    );
  }
} 