enum GenderEnum {
  male(value: 2, image: 'male.jpg'),
  female(value: 1, image: 'female.jpg');

  const GenderEnum({required this.value, required this.image});

  final int value;
  final String image;

  static GenderEnum fromValue(int value) {
    return GenderEnum.values
        .firstWhere((element) => element.value == value, orElse: () => GenderEnum.male);
  }
}
