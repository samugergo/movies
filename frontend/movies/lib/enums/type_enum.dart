enum TypeEnum {
  movie(title: 'Filmek'),
  show(title: 'Sorozatok');

  final String title; 

  const TypeEnum({
    required this.title,
  });
}