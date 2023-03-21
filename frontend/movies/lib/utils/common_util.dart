import 'package:flutter_dotenv/flutter_dotenv.dart';

chunkList(list) {
  var chunks = [];
  int chunkSize = 2;
  if(list != null) { 
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, i+chunkSize > list.length ? list.length : i + chunkSize)); 
    }
  }
  return chunks;
}

imageLink(image) {
  if(image != null) {
    final imageUrl = dotenv.env['IMAGE_URL'];
    return '$imageUrl$image';
  }
  return '';
}

originalImageLink(image) {
  if(image != null) {
    final imageUrl = dotenv.env['IMAGE_URL_ORIGINAL'];
    return '$imageUrl$image';
  }
  return '';
}

percentFormat(number) {
  final percent = (number * 10).round();
  return '$percent%';
}

getFirstNotNull(List args) {
  return args.firstWhere((element) => element != null);
}

year(String date) {
  final DateTime dateTime = DateTime.parse(date);
  return '${dateTime.year}';
}