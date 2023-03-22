enum ProviderEnum {
  streaming(title: 'Streaming'),
  rent(title: 'Kölcsönzés'),
  buy(title: 'Vásárlás');

  final String title;

  const ProviderEnum({
    required this.title
  });
}