import 'package:flutter/material.dart';

var active = Color(0xff343643);
var background = Color(0xff2B2B38); 

class ButtonSwitch extends StatefulWidget  {

  final List items;
  final int active;
  final Function onPressed;

  ButtonSwitch({
    required this.items,
    required this.active,
    required this.onPressed
  });

  @override
  State<ButtonSwitch> createState() => _ButtonSwitchState();
}

class _ButtonSwitchState extends State<ButtonSwitch> {
  @override
  Widget build(BuildContext context) {
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
            ...widget.items.asMap().entries.map((entry) => 
              Expanded(
                child: widget.active == entry.key 
                ? _ActiveButton(
                  onPressed: widget.onPressed, 
                  text: entry.value,
                  value: entry.key,
                )
                : _InactiveButton(
                  onPressed: widget.onPressed, 
                  text: entry.value,
                  value: entry.key,
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
  final int value;

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
  final int value;

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