import 'package:flutter/material.dart';
import 'package:movies/enums/grid_enum.dart';
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/state.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/locale_util.dart';
import 'package:movies/widgets/others/chip_list.dart';
import 'package:provider/provider.dart';

class FilterSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appState = getAppState(context);
    final theme = getAppTheme(context);
    final locale = getAppLocale(context);

    title(String title) {
      return Text(
        title,
        style: TextStyle(
          color: Colors.white,
        )
      );
    }

    groupTitle(String groupTitle) {
      return Center(
        child: Text(
          groupTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.primaryTextColor
          ),
        ),
      );
    }

    titles() {
      return TypeEnum.values.map((type) => getTypeLocale(type, locale)).toList();
    }

    return SizedBox(
      height: 350,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Center(
              child: ChipList(
                value: appState.type, 
                mandatory: true, 
                titles: titles(), 
                values: TypeEnum.values,
                setState: appState.setType
              ),
            ),
            SizedBox(height: 10),
            groupTitle(locale.order),
            Column(
              children: [
                ...OrderEnum.orders().map((item) => 
                  RadioListTile(
                    value: item, 
                    title: title(getOrderLocale(item, locale)),
                    activeColor: Colors.white,
                    groupValue: appState.order, 
                    onChanged: appState.setOrder
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            groupTitle(locale.layout),
            SizedBox(height: 10),
            Center(
              child: ChipList(
                value: appState.grid, 
                values: GridEnum.values, 
                mandatory: true, 
                titles: GridEnum.titles(), 
                setState: appState.setGrid
              ),
            ),
          ],
        ),
      ),
    );
  }
} 