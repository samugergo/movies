enum OrderEnum {

  popular(title: 'Legnépszerűbb', value: 'popular'),
  topRated(title: 'Legjobbra értékelt', value: 'top_rated');

  final String title;
  final String value;

  const OrderEnum({
    required this.title,
    required this.value
  });
}