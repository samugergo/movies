import 'package:flutter/material.dart';
import 'package:movies/enums/grid_enum.dart';
import 'package:movies/enums/order_enum.dart';
import 'package:movies/main.dart';
import 'package:movies/state.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:provider/provider.dart';

class FilterSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context).extension<AppColors>()!;

    onClick(order, context) {
      appState.setOrder(order);
      // appState.loadByOrder(order);
      Navigator.pop(context);
    }

    title(String title) {
      return Text(
        title,
        style: TextStyle(
          color: Colors.white,
        )
      );
    }

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

    return SizedBox(
      height: 450,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            groupTitle('Rendezés'),
            SizedBox(height: 10),
            Column(
              children: [
                ...OrderEnum.values.map((item) => 
                  RadioListTile(
                    value: item, 
                    title: title(item.title),
                    activeColor: Colors.white,
                    groupValue: appState.order, 
                    onChanged: (order) => onClick(order, context)
                  ),
                ),
              ],
            ),
            groupTitle('Elrendezés'),
            SizedBox(height: 10),
            Column(
              children: [
                ...GridEnum.values.map((item) => 
                  RadioListTile(
                    value: item.value, 
                    title: title(item.title),
                    activeColor: Colors.white,
                    groupValue: appState.itemCount, 
                    onChanged: (ic) => appState.setItemCount(ic)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 