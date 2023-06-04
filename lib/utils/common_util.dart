import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:movies/states/state.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// This function returns the main state of the application. 
/// This function should be used if you need this state.
/// 
/// [BuildContext] is the context of the build function of the widget.
AppState getAppState(BuildContext context) {
  return context.watch<AppState>();
}
/// This function returns the main theme of the application. 
/// This function should be used if you need the theme.
/// 
/// [BuildContext] is the context of the build function of the widget.
AppColors getAppTheme(BuildContext context) {
  return Theme.of(context).extension<AppColors>()!;
}
/// This function returns the main locale of the application. 
/// This function should be used if you need the locale.
/// 
/// [BuildContext] is the context of the build function of the widget.
AppLocalizations getAppLocale(BuildContext context) {
  return AppLocalizations.of(context);
}
/// This function returns a sub list of the given list. You can specify the size of the sublist.
/// It makes sure that if the list is not longer than the given size it doesn't throw any error.
/// 
/// [List] is the list to make sublist from.
/// [int] is the size of the sublist.
sublist(List list, int count) {
  if (list.length <= count) {
    return list;
  }
  return list.sublist(0, count);
}
/// This function creates an image link from the given image id. There are 3 quality of each 
/// image this function makes a link to an image with 500px width.
/// 
/// [String] is the id of the image
imageLink(String? image) {
  if(image != null &&  image != '') {
    final imageUrl = dotenv.env['IMAGE_URL'];
    return '$imageUrl$image';
  }
  return '';
}
/// This function creates an image link from the given image id. There are 3 quality of each 
/// image this function makes a link to an image with the original quality.
/// 
/// [String] is the id of the image
originalImageLink(String? image) {
  if(image != null &&  image != '') {
    final imageUrl = dotenv.env['IMAGE_URL_ORIGINAL'];
    return '$imageUrl$image';
  }
  return '';
}
/// This function creates an image link from the given image id. There are 3 quality of each 
/// image this function makes a link to an image with the lowest quality possible.
/// This function is used when you need color calculations from an image.
/// 
/// [String] is the id of the image
lowImageLink(String? image) {
  if(image != null && image != '') {
    final imageUrl = dotenv.env['IMAGE_URL_LOW'];
    return '$imageUrl$image';
  }
  return '';
}
/// This function returns the first not null element of the given list.
/// It assumes that the list has a not null element!
/// 
/// [List] is the list of the elements to check.
getFirstNotNull(List args) {
  return args.firstWhere((element) => element != null);
}
/// This function returns the year from the given date.
/// 
/// [String] is the date.
year(String date) {
  if(date != '') {
    final DateTime dateTime = DateTime.parse(date);
    return '${dateTime.year}';
  }
  return '';
}
/// This function format the given to a custom format.
/// 
/// [String] is the date to format.
dateFormat(date) {
  if(date != '') {
    final DateFormat formatter = DateFormat('yyyy.MM.dd');
    return formatter.format(DateTime.parse(date));
  }
  return '';
}
/// This function splits the given minutes into hours and minutes.
/// 
/// [int] is the number of minutes.
/// [AppLocalizations] locale of the app.
timeFormat(int minutes, AppLocalizations locale) {
  final hours = minutes ~/ 60;
  final mins = minutes % 60;
  return hours > 0 ? locale.hourMin(hours, mins) : locale.mins(mins);
}