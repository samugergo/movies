import 'package:movies/utils/common_util.dart';

import '../enums/property_enum.dart';

T getField<T>(Map<String, dynamic> json, PropertyEnum prop) {
  return json[prop.key] ?? prop.defaultVal;
}

T? getFieldNullable<T>(Map<String, dynamic> json, PropertyEnum prop) {
  return json[prop.key];
}

T getFieldList<T>(Map<String, dynamic> json, List<PropertyEnum> props) {
  final args = props.map((e) => json[e.key]).toList();
  return getFirstNotNull(args);
}

String getImage(Map<String, dynamic> json, PropertyEnum prop) {
  final image = json[prop.key];
  if (image != null) {
    return imageLink(image);
  }
  return '';
}

double getFieldDouble(Map<String, dynamic> json, PropertyEnum prop) {
  return json[prop.key].toDouble();
}
