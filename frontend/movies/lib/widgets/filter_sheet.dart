import 'package:flutter/material.dart';

class FilterSheet extends StatelessWidget {

  final int order;
  final Function updateOrder;

  FilterSheet({
    required this.order,
    required this.updateOrder,
  });

  update(order) {
    updateOrder(order);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
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
                RadioListTile(
                  value: 0, 
                  title: Text(
                    'Legnépszerűbb',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  activeColor: Colors.white,
                  groupValue: order, 
                  onChanged: update
                ),
                RadioListTile(
                  value: 1, 
                  title: Text(
                    'Legjobbra értékelt',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  activeColor: Colors.white,
                  groupValue: order, 
                  onChanged: update
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}