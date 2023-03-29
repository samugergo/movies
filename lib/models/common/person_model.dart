class PersonModel {
  final int id;
  final String name;
  final String biography;
  final String birthday;
  final String birthPlace;
  final String image;

  PersonModel({
    required this.id,
    required this.name,
    required this.biography,
    required this.birthday,
    required this.birthPlace,
    required this.image,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      name: json['name'],
      biography: json['biography'] ?? '',
      birthday: json['birthday'] ?? '',
      birthPlace: json['place_of_birth'] ?? '',
      image: json['profile_path'] ?? '',
    );
  }
}