import 'package:flutter/material.dart';

class ChipList<T> extends StatelessWidget {
  ChipList({
    required T value,
    required List<T> values,
    required bool mandatory,
    required List<String> titles,
    required Function(T) setState,
  }) : 
  _value = value,
  _values = values,
  _titles = titles,
  _mandatory = mandatory, 
  _setState = setState;

  final T _value;
  final List<T> _values;
  final bool _mandatory;
  final List<String> _titles;
  final Function(T) _setState;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      children: List<Widget>.generate(
        _titles.length,
        (int index) {
          return ChoiceChip(
            label: Text(_titles[index]),
            labelStyle: TextStyle(
              color: _value == _values[index] ? Colors.black : Colors.white,
            ),
            backgroundColor: Colors.black87,
            selectedColor: Colors.white,
            selected: _value == _values[index],
            onSelected: (bool selected) {
              _setState(_values[index]);
            },
          );
        },
      ).toList(),
    );
  }
  
}