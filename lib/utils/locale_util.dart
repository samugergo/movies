import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/type_enum.dart';

String getTypeLocale(TypeEnum type, AppLocalizations locale) {
  switch (type) {
    case TypeEnum.movie: 
      return locale.movies;
    case TypeEnum.show:
      return locale.shows;
    case TypeEnum.person:
      return locale.person;
  }
}

String getOrderLocale(OrderEnum order, AppLocalizations locale) {
  switch (order) {
    case OrderEnum.popular: 
      return locale.popular;
    case OrderEnum.topRated:
      return locale.topRated;
    default:
      return '';
  }
}