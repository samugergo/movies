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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Row(
          children: [
            ...items.map((item) => 
              Expanded(
                child: appState.type == item 
                ? _ActiveButton(
                  onPressed: onClick, 
                  text: item.title,
                  value: item,
                )
                : _InactiveButton(
                  onPressed: onClick, 
                  text: item.title,
                  value: item,
                )
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }
}

class _ActiveButton extends StatelessWidget  {

  final Function onPressed;
  final String text;
  final TypeEnum value;

  _ActiveButton({
    required this.onPressed,
    required this.text,
    required this.value
  }); 

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(value),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(active),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}

class _InactiveButton extends StatelessWidget  {

  final Function onPressed;
  final String text;
  final TypeEnum value;

  _InactiveButton({
    required this.onPressed,
    required this.text,
    required this.value
  }); 

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(value), 
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        overlayColor: MaterialStateProperty.all<Color>(active.withAlpha(100)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
        ),
      )
    );
  }
}