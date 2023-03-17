class Providers {
  final List<Provider> rent;
  final List<Provider> buy;
  final List<Provider> streaming;  

  Providers({
    required this.rent,
    required this.buy,
    required this.streaming
  });

  factory Providers.fromJson(Map<String, dynamic> json) {
    return Providers(
      rent: json['rent'].map((r) => Provider.fromJson(r)), 
      buy: json['buy'].map((b) => Provider.fromJson(b)),  
      streaming: json['streaming'].map((s) => Provider.fromJson(s))
    );
  }
}


class Provider {
  final int id;
  final String title;
  final String image;

  Provider({
    required this.id,
    required this.title,
    required this.image,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'], 
      title: json['title'], 
      image: json['image']
    );
  }
}