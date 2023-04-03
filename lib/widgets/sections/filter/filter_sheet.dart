import 'package:flutter/material.dart';
import 'package:movies/enums/grid_enum.dart';
import 'package:movies/enums/order_enum.dart';
import 'package:movies/main.dart';
import 'package:provider/provider.dart';

class FilterSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();
    const items = OrderEnum.values;

    onClick(order, context) {
      appState.setOrder(order);
      appState.loadByOrder(order);
      Navigator.pop(context);
    }

    return SizedBox(
      height: 450,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Text(
              'Rendezés',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                ...items.map((item) => 
                  RadioListTile(
                    value: item, 
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    activeColor: Colors.white,
                    groupValue: appState.order, 
                    onChanged: (order) => onClick(order, context)
                  ),
                ),
              ],
            ),
            Text(
              'Elrendezés',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                ...GridEnum.values.map((item) => 
                  RadioListTile(
                    value: item.value, 
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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