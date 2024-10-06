import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/errors/failure.dart';
import 'package:final_flashcard/features/authentication/data/data_source/authentication_local_data_source.dart';
import 'package:final_flashcard/features/authentication/data/data_source/authentication_remote_data_source.dart';
import 'package:final_flashcard/features/authentication/data/model/change_password_request.dart';
import 'package:final_flashcard/features/authentication/data/model/login_request.dart';
import 'package:final_flashcard/features/authentication/data/model/register_request.dart';
import 'package:final_flashcard/features/authentication/data/model/reset_password_request.dart';
import 'package:final_flashcard/features/authentication/data/model/verify_otp_request.dart';
import 'package:final_flashcard/features/authentication/domain/repository/authetication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource _authenticationRemoteDataSource;
  final AuthenticationLocalDataSource _authenticationLocalDataSource;

  AuthenticationRepositoryImpl(
    this._authenticationRemoteDataSource,
    this._authenticationLocalDataSource,
  );

  @override
  ResultVoid createUser({
    required String email,
    required String password,
    required String name,
    required DateTime dateOfBirth,
  }) async {
    try {
      await _authenticationRemoteDataSource.register(
        RegistrationRequest(
          email: email,
          password: password,
          name: name,
          dateOfBirth: dateOfBirth,
        ),
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response!.data['data'],
          statusCode: e.response!.statusCode!,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultFuture<DataMap> getEmailAndPassword() async {
    try {
      final data = await _authenticationLocalDataSource.getEmailAndPassword();
      if (data[GlobalConstants.kEmailKey] == null ||
          data[GlobalConstants.kPasswordKey] == null) {
        return const Left(
          CacheFailure(
            message: 'no_data',
            statusCode: 404,
          ),
        );
      }
      return Right(data);
    } catch (e) {
      return Left(
        CacheFailure(
          message: e.toString(),
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultVoid loginAccount(
      {required String email, required String password}) async {
    try {
      final response = await _authenticationRemoteDataSource.login(
        LoginRequest(
          email: email,
          password: password,
        ),
      );
      await _authenticationLocalDataSource.saveEmailAndPassword(
        email,
        password,
      );
      await _authenticationLocalDataSource.saveUser(response.user);
      await _authenticationLocalDataSource.saveToken(response.token);
      return const Right(null);
    } on DioException catch (e) {
      if (e.response!.statusCode == 401) {
        return Left(
          ApiFailure(
            message: 'invalid_email_or_password',
            statusCode: e.response!.statusCode!,
          ),
        );
      }
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response!.statusCode!,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultVoid requestOtpPassword(String email) async {
    try {
      await _authenticationRemoteDataSource.createOtpRequest(
        ChangePasswordRequest(email: email),
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response!.data['data'],
          statusCode: e.response!.statusCode!,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultFuture<bool> verifyOtp(
      {required String otp, required String email}) async {
    try {
      final response = await _authenticationRemoteDataSource.verifyOtp(
        VerifyOtpRequest(email: email, otp: otp),
      );
      return Right(response);
    } on DioException catch (e) {
      final message = e.response!.statusCode == 401
          ? 'invalid_otp'
          : 'something_went_wrong';
      return Left(
        ApiFailure(
          message: message,
          statusCode: e.response!.statusCode!,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultVoid resetPassword(
      {required String email, required String password}) async {
    try {
      await _authenticationRemoteDataSource.resetPassword(
        ResetPasswordRequest(
          email: email,
          password: password,
        ),
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response!.data['data'],
          statusCode: e.response!.statusCode!,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultVoid loginWithGoogle({required String idToken}) async {
    try {
      final dataMap = {
        'token': idToken,
      };
      final response =
          await _authenticationRemoteDataSource.socialLogin(dataMap);
      await _authenticationLocalDataSource.saveUser(response.user);
      await _authenticationLocalDataSource.saveToken(response.token);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response!.data['data'],
          statusCode: e.response!.statusCode!,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
          statusCode: 500,
        ),
      );
    }
  }
}
