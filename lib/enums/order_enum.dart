enum OrderEnum {

  popular(title: 'Legnépszerűbb', value: 'popular', localeKey: 'popular'),
  topRated(title: 'Legjobbra értékelt', value: 'top_rated', localeKey: 'topRated'),
  upcoming(title: 'Közeljővőbeli', value: 'upcoming', localeKey: 'upcoming'),
  onTheAir(title: 'Legnépszerűbb', value: 'airing_today', localeKey: ''),
  ;

  final String title;
  final String value;
  final String localeKey;

  const OrderEnum({
    required this.title,
    required this.value,
    required this.localeKey
  });

  static List<String> titles() {
    return [OrderEnum.popular, OrderEnum.topRated].map((e) => e.title).toList();
  }

  static List<OrderEnum> orders() {
    return [OrderEnum.popular, OrderEnum.topRated];
  }
}