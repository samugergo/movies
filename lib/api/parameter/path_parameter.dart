import 'package:movies/enums/resource/param_enum.dart';

class PathParameter {
  const PathParameter({
    required this.key,
    required this.value,
  });

  final ParamEnum key;
  final dynamic value;

  @override
  String toString() {
    return "${key.value}=$value";
  }
}