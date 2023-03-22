import 'package:movies/utils/common_util.dart';

class Providers {
  List? rent = [];
  List? buy = [];
  List? streaming = [];  

  Providers({
    this.rent,
    this.buy,
    this.streaming
  });

  factory Providers.fromJson(Map<String, dynamic> json) {
    return Providers(
      rent: json['rent']?.map((r) => Provider.fromJson(r)).toList(), 
      buy: json['buy']?.map((b) => Provider.fromJson(b)).toList(),  
      streaming: json['flatrate']?.map((s) => Provider.fromJson(s)).toList()
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
      id: json['provider_id'], 
      title: json['provider_name'], 
      image: imageLink(json['logo_path'])
    );
  }
}