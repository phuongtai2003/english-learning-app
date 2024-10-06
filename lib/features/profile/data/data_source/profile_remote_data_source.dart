import 'dart:io';

import 'package:dio/dio.dart';
import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/features/profile/data/model/change_email_request.dart';
import 'package:final_flashcard/features/profile/data/model/change_name_request.dart';
import 'package:final_flashcard/features/profile/data/model/change_password_request.dart';
import 'package:final_flashcard/features/profile/data/model/get_profile_response.dart';
import 'package:final_flashcard/features/profile/data/model/send_otp_new_email_request.dart';
import 'package:final_flashcard/features/profile/data/model/verify_password_request.dart';
import 'package:retrofit/http.dart';

part 'profile_remote_data_source.g.dart';

@RestApi(baseUrl: GlobalConstants.baseUrl)
abstract class ProfileRemoteDataSource {
  factory ProfileRemoteDataSource(Dio dio) = _ProfileRemoteDataSource;

  @GET('/profile/get')
  Future<GetProfileResponse> getProfile();

  @POST('profile/update-image')
  @MultiPart()
  Future<String> updateImage(@Part() File image);

  @POST('profile/update-push-notification')
  Future<bool> updatePushNotification(@Field() bool pushNotification);

  @POST('profile/update-save-offline')
  Future<bool> updateSaveOffline(@Field() bool saveOffline);

  @POST('profile/change-name')
  Future<GetProfileResponse> changeName({
    @Body() required ChangeNameRequest request,
  });

  @POST('profile/verify-password')
  Future<bool> verifyPassword({
    @Body() required VerifyPasswordRequest request,
  });

  @POST('profile/request-otp-change-email')
  Future<bool> sendOtpNewEmail({
    @Body() required SendOtpNewEmailRequest request,
  });

  @POST('profile/verify-otp-change-email')
  Future<String> changeEmail({
    @Body() required ChangeEmailRequest request,
  });

  @PUT('profile/change-password')
  Future<bool> changePassword({
    @Body() required ChangePasswordRequest request,
  });
}
