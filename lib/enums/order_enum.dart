enum OrderEnum {

  popular(title: 'Legnépszerűbb', value: 'popular'),
  topRated(title: 'Legjobbra értékelt', value: 'top_rated'),
  upcoming(title: 'Közeljővőbeli', value: 'upcoming'),
  onTheAir(title: 'Legnépszerűbb', value: 'airing_today'),
  ;

  final String title;
  final String value;

  const OrderEnum({
    required this.title,
    required this.value
  });
}