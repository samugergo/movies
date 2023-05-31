// ignore_for_file: constant_identifier_names

enum GridEnum {
  Nx2(title: '2xN', value: 2),
  Nx3(title: '3xN', value: 3),
  Nx4(title: '4xN', value: 4),
  Nx5(title: '5xN', value: 5);

  final String title;
  final int value;

  const GridEnum({
    required this.title,
    required this.value,
  });

  static List<String> titles() {
    return GridEnum.values.map((e) => e.title).toList(); 
  }

  static GridEnum from(int val) {
    return GridEnum.values.firstWhere((e) => e.value == val);
  }
}