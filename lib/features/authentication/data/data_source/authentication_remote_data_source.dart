import 'package:dio/dio.dart';
import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/features/authentication/data/model/change_password_request.dart';
import 'package:final_flashcard/features/authentication/data/model/login_request.dart';
import 'package:final_flashcard/features/authentication/data/model/login_response.dart';
import 'package:final_flashcard/features/authentication/data/model/register_request.dart';
import 'package:final_flashcard/features/authentication/data/model/reset_password_request.dart';
import 'package:final_flashcard/features/authentication/data/model/verify_otp_request.dart';
import 'package:retrofit/http.dart';

part 'authentication_remote_data_source.g.dart';

@RestApi(baseUrl: GlobalConstants.baseUrl)
abstract class AuthenticationRemoteDataSource {
  factory AuthenticationRemoteDataSource(Dio dio) =
      _AuthenticationRemoteDataSource;

  @POST('auth/register')
  Future<void> register(@Body() RegistrationRequest registrationRequest);

  @POST('auth/login')
  Future<LoginResponse> login(@Body() LoginRequest loginRequest);

  @POST('auth/change-password-request')
  Future<void> createOtpRequest(
      @Body() ChangePasswordRequest changePasswordRequest);

  @POST('auth/verify-otp')
  Future<bool> verifyOtp(@Body() VerifyOtpRequest request);

  @POST('auth/reset-password')
  Future<void> resetPassword(@Body() ResetPasswordRequest request);

  @POST('auth/social-login')
  Future<LoginResponse> socialLogin(@Body() DataMap body);
}
