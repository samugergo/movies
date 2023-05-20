import 'package:flutter/material.dart';

class ChipList extends StatelessWidget {
  ChipList({
    required int value,
    required bool mandatory,
    required List<String> list,
    required Function(int) setState,
  }) : 
  _value = value,
  _list = list,
  _mandatory = mandatory, 
  _setState = setState;

  final int _value;
  final bool _mandatory;
  final List<String> _list;
  final Function(int) _setState;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      children: List<Widget>.generate(
        _list.length,
        (int index) {
          return ChoiceChip(
            label: Text(_list[index]),
            labelStyle: TextStyle(
              color: _value == index ? Colors.black : Colors.white,
            ),
            backgroundColor: Colors.black87,
            selected: _value == index,
            onSelected: (bool selected) {
              _setState(index);
            },
          );
        },
      ).toList(),
    );
  }
  
}