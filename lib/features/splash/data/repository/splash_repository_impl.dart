import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/errors/failure.dart';
import 'package:final_flashcard/features/splash/data/data_source/splash_local_data_source.dart';
import 'package:final_flashcard/features/splash/data/data_source/splash_remote_data_source.dart';
import 'package:final_flashcard/features/splash/data/model/configuration_model.dart';
import 'package:final_flashcard/features/splash/domain/repository/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource _splashLocalDataSource;
  final SplashRemoteDataSource _splashRemoteDataSource;

  SplashRepositoryImpl(
    this._splashLocalDataSource,
    this._splashRemoteDataSource,
  );

  @override
  ResultFuture<ConfigurationModel> getConfiguration() async {
    ConfigurationModel config = await _splashLocalDataSource.getConfiguration();
    try {
      final res = await _splashRemoteDataSource.validate();
      if (res) {
        return Right(config);
      } else {
        final user = _splashLocalDataSource.getUser();
        if (user == null) {
          await _splashLocalDataSource.removeToken();
          await _splashLocalDataSource.removeUser();
          final newConfig = ConfigurationModel.fromEntity(
            config.copyWith(
              token: '',
            ),
          );
          return Right(newConfig);
        } else {
          return Right(config);
        }
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == null) {
        final user = _splashLocalDataSource.getUser();
        if (user == null) {
          await _splashLocalDataSource.removeToken();
          final newConfig = ConfigurationModel.fromEntity(
            config.copyWith(
              token: '',
            ),
          );
          return Right(newConfig);
        } else {
          return Right(config);
        }
      } else if (e.response?.statusCode == HttpStatus.forbidden) {
        await _splashLocalDataSource.removeToken();
        await _splashLocalDataSource.removeUser();
        final newConfig = ConfigurationModel.fromEntity(
          config.copyWith(
            token: '',
          ),
        );
        return Right(newConfig);
      } else {
        return Left(
          ApiFailure(
            message: 'something_went_wrong',
            statusCode: e.response?.statusCode ?? 500,
          ),
        );
      }
    } catch (e) {
      return const Left(
        CacheFailure(
          message: 'something_went_wrong',
          statusCode: 500,
        ),
      );
    }
  }
}
