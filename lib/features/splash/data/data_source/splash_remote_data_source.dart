import 'package:dio/dio.dart';
import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:retrofit/http.dart';
part 'splash_remote_data_source.g.dart';

@RestApi(baseUrl: GlobalConstants.baseUrl)
abstract class SplashRemoteDataSource {
  factory SplashRemoteDataSource(Dio dio) = _SplashRemoteDataSource;

  @GET('splash/validate')
  Future<bool> validate();
}
