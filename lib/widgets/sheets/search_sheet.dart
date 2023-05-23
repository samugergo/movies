import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/others/chip_list.dart';

class SearchSheet extends StatefulWidget {
  SearchSheet({
    required this.type,
    required this.function,
  }); 

  final dynamic type;
  final Function(dynamic) function;

  @override
  State<SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<SearchSheet> {
  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 120,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Center(
          child: ChipList(
            value: widget.type, 
            mandatory: true, 
            titles: TypeEnum.titles(), 
            values: TypeEnum.values,
            setState: widget.function
          ),
        ),
      ),
    );
  }
}