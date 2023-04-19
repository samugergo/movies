import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies/api/parameter/path_parameter.dart';
import 'package:movies/api/resource/resource.dart';
import 'package:movies/enums/resource/param_enum.dart';

class MovieDBResource extends Resource {
  MovieDBResource() : super(
    baseUrl: dotenv.env[ParamEnum.BASE_URL.name]!, 
    apiKey: dotenv.env[ParamEnum.API_KEY.name]!
  );

  @override
  doApiCall(String endpoint, List<PathParameter> params) async {
    params.addAll([
      PathParameter(
        key: ParamEnum.LANG, 
        value: dotenv.env[ParamEnum.LANG.name]
      ),
      PathParameter(
        key: ParamEnum.REGION, 
        value: dotenv.env[ParamEnum.REGION.name]
      ),
    ]);
    return await super.doApiCall(endpoint, params);
  }
}