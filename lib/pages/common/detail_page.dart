import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';

abstract class DetailPage extends StatefulWidget {
  final int id;
  final TypeEnum type;

  DetailPage({
    super.key,
    required this.id,
    required this.type,
  });
}
