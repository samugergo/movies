import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:movies/main.dart';
import 'package:movies/states/state.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppState getAppState(BuildContext context) {
  return context.watch<AppState>();
}

AppColors getAppTheme(BuildContext context) {
  return Theme.of(context).extension<AppColors>()!;
}

AppLocalizations getAppLocale(BuildContext context) {
  return AppLocalizations.of(context);
}

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

sublist(List list, int count) {
  if (list.length <= count) {
    return list;
  }
  return list.sublist(0, count);
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

timeFormat(int minutes, AppLocalizations locale) {
  final hours = minutes ~/ 60;
  final mins = minutes % 60;
  return hours > 0 ? locale.hourMin(hours, mins) : locale.mins(mins);
}