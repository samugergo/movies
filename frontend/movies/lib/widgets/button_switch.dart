import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/main.dart';
import 'package:provider/provider.dart';

var active = Color(0xff343643);
var background = Color(0xff2B2B38); 

class ButtonSwitch extends StatelessWidget  {

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();
    const items = TypeEnum.values;

    onClick(type) {
      appState.setType(type);
      if (appState.isEmptyByType(type)) {
        appState.loadByType(type);
      }
    }

    return Card(
      color: background,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Row(
          children: [
            ...items.map((item) => 
              Expanded(
                child: TextButton(
                  onPressed: () => onClick(item),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      appState.type == item ? active : Colors.transparent
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }
}