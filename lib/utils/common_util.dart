import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

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
  if(image != null &&  image != '') {
    final imageUrl = dotenv.env['IMAGE_URL'];
    return '$imageUrl$image';
  }
  return '';
}

originalImageLink(image) {
  if(image != null &&  image != '') {
    final imageUrl = dotenv.env['IMAGE_URL_ORIGINAL'];
    return '$imageUrl$image';
  }
  return '';
}

lowImageLink(image) {
  if(image != null && image != '') {
    final imageUrl = dotenv.env['IMAGE_URL_LOW'];
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
  if(date != '') {
    final DateTime dateTime = DateTime.parse(date);
    return '${dateTime.year}';
  }
  return '';
}

dateFormat(date) {
  if(date != '') {
    final DateFormat formatter = DateFormat('yyyy.MM.dd');
    return formatter.format(DateTime.parse(date));
  }
  return '';
}

timeFormat(int minutes) {
  final hours = minutes ~/ 60;
  final mins = minutes % 60;
  return hours > 0 ? '$hours ó $mins p' : '$mins p';
}