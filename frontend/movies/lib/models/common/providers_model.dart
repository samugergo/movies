import 'package:movies/enums/provider_enum.dart';
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

  _isRent() {
    return rent != null && rent!.isNotEmpty;
  }

  _isBuy() {
    return buy != null && buy!.isNotEmpty;
  }

  _isStreaming() {
    return streaming != null && streaming!.isNotEmpty;
  }

  getByEnum(ProviderEnum provider) {
    switch (provider) {
      case ProviderEnum.rent: return rent;
      case ProviderEnum.buy: return buy;
      case ProviderEnum.streaming: return streaming;
    }
  }

  isNotNullByEnum(ProviderEnum provider) {
    switch (provider) {
      case ProviderEnum.rent: return _isRent();
      case ProviderEnum.buy: return _isBuy();
      case ProviderEnum.streaming: return _isStreaming();
    }
  }

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