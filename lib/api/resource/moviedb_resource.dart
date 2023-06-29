import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies/api/parameter/path_parameter.dart';
import 'package:movies/api/resource/resource.dart';
import 'package:movies/enums/resource/param_enum.dart';

class MovieDBResource extends Resource {
  MovieDBResource()
      : super(
            baseUrl: dotenv.env[ParamEnum.BASE_URL.name]!,
            apiKey: dotenv.env[ParamEnum.API_KEY.name]!);

  getLanguage() {
    const valid = ['en_US', 'hu_HU'];
    if (valid.contains(Platform.localeName)) {
      return Platform.localeName.replaceFirst(RegExp('_'), '-');
    }
    return dotenv.env[ParamEnum.LANG.name];
  }

  @override
  doApiCall(String endpoint, List<PathParameter> params) async {
    params.addAll([
      PathParameter(key: ParamEnum.LANG, value: getLanguage()),
      PathParameter(key: ParamEnum.REGION, value: dotenv.env[ParamEnum.REGION.name])
    ]);
    return await super.doApiCall(endpoint, params);
  }

  doApiCallOnlyApiKey(String endpoint, List<PathParameter> params) async {
    return await super.doApiCall(endpoint, params);
  }
}
