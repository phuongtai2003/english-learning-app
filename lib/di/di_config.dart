import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:final_flashcard/configs/storage/app_prefs.dart';
import 'package:final_flashcard/features/folder/data/data_source/folder_remote_data_source.dart';
import 'package:final_flashcard/features/folder/data/repository/folder_repository_impl.dart';
import 'package:final_flashcard/features/folder/domain/repository/folder_repository.dart';
import 'package:final_flashcard/features/learning/data/data_source/topic_learning_remote_data_source.dart';
import 'package:final_flashcard/features/rankings/data/data_source/rankings_remote_data_source.dart';
import 'package:final_flashcard/features/search/data/data_source/search_remote_data_source.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:final_flashcard/di/di_config.config.dart';
import 'package:final_flashcard/features/authentication/data/data_source/authentication_local_data_source.dart';
import 'package:final_flashcard/features/authentication/data/data_source/authentication_remote_data_source.dart';
import 'package:final_flashcard/features/authentication/data/repository/authentication_repository_impl.dart';
import 'package:final_flashcard/features/authentication/domain/repository/authetication_repository.dart';
import 'package:final_flashcard/features/profile/data/data_source/profile_local_data_source.dart';
import 'package:final_flashcard/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:final_flashcard/features/profile/data/repository/profile_repository_impl.dart';
import 'package:final_flashcard/features/profile/domain/repository/profile_repository.dart';
import 'package:final_flashcard/features/splash/data/data_source/splash_local_data_source.dart';
import 'package:final_flashcard/features/splash/data/data_source/splash_remote_data_source.dart';
import 'package:final_flashcard/features/splash/data/repository/splash_repository_impl.dart';
import 'package:final_flashcard/features/splash/domain/repository/splash_repository.dart';
import 'package:final_flashcard/features/topic/data/data_source/topic_remote_data_source.dart';
import 'package:final_flashcard/features/topic/data/repository/topic_repository_impl.dart';
import 'package:final_flashcard/features/topic/domain/repository/topic_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() => $initGetIt(getIt);

@module
abstract class AppModule {
  @preResolve
  Future<AppPrefs> get prefs => AppPrefs().initialize();

  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();

  @lazySingleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(
      _createAuthInterceptor(getIt.get()),
    );
    if (kDebugMode) {
      dio.interceptors.add(_createLogInterceptor());
    }
    dio.interceptors.add(_createCacheInterceptor());

    return dio;
  }

  Interceptor _createAuthInterceptor(AppPrefs appPrefs) {
    return InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        final token = appPrefs.getToken();

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    );
  }

  Interceptor _createLogInterceptor() {
    return LogInterceptor(requestBody: true, responseBody: true);
  }

  DioCacheInterceptor _createCacheInterceptor() {
    return DioCacheInterceptor(
      options: CacheOptions(
        store: MemCacheStore(),
        policy: CachePolicy.request,
        hitCacheOnErrorExcept: [401, 403],
      ),
    );
  }

  @lazySingleton
  Box<dynamic> get box => Hive.box<dynamic>('final_flashcard');

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn();

  @lazySingleton
  SplashLocalDataSource get splashLocalDataSource =>
      SplashLocalDataSourceImpl(getIt.get());

  @lazySingleton
  SplashRemoteDataSource get splashRemoteDataSource =>
      SplashRemoteDataSource(getIt.get());

  @lazySingleton
  SplashRepository get splashRepository => SplashRepositoryImpl(
        getIt.get(),
        getIt.get(),
      );

  @lazySingleton
  AuthenticationLocalDataSource get authenticationLocalDataSource =>
      AuthenticationLocalDataSourceImpl(getIt.get());

  @lazySingleton
  AuthenticationRemoteDataSource get authenticationRemoteDataSource =>
      AuthenticationRemoteDataSource(getIt.get());

  @lazySingleton
  AuthenticationRepository get authenticationRepository =>
      AuthenticationRepositoryImpl(
        getIt.get(),
        getIt.get(),
      );

  @lazySingleton
  ProfileRepository get profileRepository => ProfileRepositoryImpl(
        getIt.get(),
        getIt.get(),
      );

  @lazySingleton
  ProfileLocalDataSource get profileLocalDataSource =>
      ProfileLocalDataSourceImpl(
        getIt.get(),
        getIt.get(),
      );

  @lazySingleton
  ProfileRemoteDataSource get profileRemoteDataSource =>
      ProfileRemoteDataSource(getIt.get());

  @lazySingleton
  TopicRemoteDataSource get topicRemoteDataSource =>
      TopicRemoteDataSource(getIt.get());

  @lazySingleton
  TopicRepository get topicRepository => TopicRepositoryImpl(
        getIt.get(),
        getIt.get(),
      );

  @lazySingleton
  FolderRemoteDataSource get folderRemoteDataSource =>
      FolderRemoteDataSource(getIt.get());

  @lazySingleton
  FolderRepository get folderRepository => FolderRepositoryImpl(
        getIt.get(),
      );

  @lazySingleton
  TopicLearningRemoteDataSource get topicLearningRemoteDataSource =>
      TopicLearningRemoteDataSource(getIt.get());

  @lazySingleton
  SearchRemoteDataSource get searchRemoteDataSource =>
      SearchRemoteDataSource(getIt.get());

  @lazySingleton
  ListToCsvConverter get listToCsvConverter => const ListToCsvConverter();

  @lazySingleton
  CsvToListConverter get csvToListConverter => const CsvToListConverter();

  @lazySingleton
  RankingsRemoteDataSource get rankingsRemoteDataSource =>
      RankingsRemoteDataSource(getIt.get());
}
