import 'package:flutter/material.dart';

class ChipList<T> extends StatelessWidget {
  ChipList({
    required T value,
    required List<T> values,
    required bool mandatory,
    required List<String> titles,
    required this.setState,
  }) : 
  _value = value,
  _values = values,
  _titles = titles,
  _mandatory = mandatory;

  final T _value;
  final List<T> _values;
  final bool _mandatory;
  final List<String> _titles;
  final Function(T) setState;

  get titles => _titles;
  get value => _value;
  get values => _values;

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
            backgroundColor: Color(0xff353443),
            selectedColor: Colors.white,
            selected: _value == _values[index],
            onSelected: (bool selected) {
              setState(_values[index]);
            },
          );
        },
      ).toList(),
    );
  }
  
}