// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i8;
import 'package:csv/csv.dart' as _i9;
import 'package:dio/dio.dart' as _i10;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i16;
import 'package:hive/hive.dart' as _i7;
import 'package:image_picker/image_picker.dart' as _i19;
import 'package:injectable/injectable.dart' as _i2;

import '../configs/storage/app_prefs.dart' as _i3;
import '../configs/storage/hive_storage.dart' as _i18;
import '../core/utils/helper.dart' as _i17;
import '../features/authentication/data/data_source/authentication_local_data_source.dart'
    as _i4;
import '../features/authentication/data/data_source/authentication_remote_data_source.dart'
    as _i5;
import '../features/authentication/domain/repository/authetication_repository.dart'
    as _i6;
import '../features/authentication/domain/use_case/login.dart' as _i20;
import '../features/authentication/domain/use_case/registration.dart' as _i27;
import '../features/authentication/domain/use_case/request_otp_password.dart'
    as _i30;
import '../features/authentication/domain/use_case/reset_password.dart' as _i31;
import '../features/authentication/domain/use_case/social_login.dart' as _i36;
import '../features/authentication/domain/use_case/verify_otp.dart' as _i49;
import '../features/folder/data/data_source/folder_remote_data_source.dart'
    as _i11;
import '../features/folder/domain/repository/folder_repository.dart' as _i12;
import '../features/folder/domain/use_case/add_folder.dart' as _i51;
import '../features/folder/domain/use_case/add_folder_to_topic.dart' as _i52;
import '../features/folder/domain/use_case/edit_folder.dart' as _i62;
import '../features/folder/domain/use_case/get_available_folders.dart' as _i13;
import '../features/folder/domain/use_case/get_folder_detail.dart' as _i14;
import '../features/folder/domain/use_case/get_user_folders.dart' as _i15;
import '../features/folder/domain/use_case/remove_folder.dart' as _i28;
import '../features/folder/domain/use_case/remove_topic_from_folder.dart'
    as _i29;
import '../features/learning/data/data_source/topic_learning_remote_data_source.dart'
    as _i40;
import '../features/learning/data/repository/topic_learning_repository_impl.dart'
    as _i42;
import '../features/learning/domain/repository/topic_learning_repository.dart'
    as _i41;
import '../features/learning/domain/use_cases/update_learning_statistics.dart'
    as _i46;
import '../features/profile/data/data_source/profile_local_data_source.dart'
    as _i21;
import '../features/profile/data/data_source/profile_remote_data_source.dart'
    as _i22;
import '../features/profile/domain/repository/profile_repository.dart' as _i23;
import '../features/profile/domain/use_case/change_dark_mode.dart' as _i55;
import '../features/profile/domain/use_case/change_language.dart' as _i56;
import '../features/profile/domain/use_case/change_name.dart' as _i57;
import '../features/profile/domain/use_case/change_password.dart' as _i58;
import '../features/profile/domain/use_case/change_push_notification.dart'
    as _i59;
import '../features/profile/domain/use_case/change_save_offline.dart' as _i60;
import '../features/profile/domain/use_case/get_profile.dart' as _i67;
import '../features/profile/domain/use_case/logout.dart' as _i72;
import '../features/profile/domain/use_case/pick_profile_image.dart' as _i73;
import '../features/profile/domain/use_case/send_otp_new_email.dart' as _i35;
import '../features/profile/domain/use_case/verify_new_email.dart' as _i48;
import '../features/profile/domain/use_case/verify_password.dart' as _i50;
import '../features/rankings/data/data_source/rankings_remote_data_source.dart'
    as _i24;
import '../features/rankings/data/repository/rankings_repository_impl.dart'
    as _i26;
import '../features/rankings/domain/repository/rankings_repository.dart'
    as _i25;
import '../features/rankings/domain/use_case/get_rankings.dart' as _i68;
import '../features/search/data/data_source/search_remote_data_source.dart'
    as _i32;
import '../features/search/data/repository/search_repository_impl.dart' as _i34;
import '../features/search/domain/repository/search_repository.dart' as _i33;
import '../features/search/domain/use_case/fetch_search_topics.dart' as _i64;
import '../features/splash/data/data_source/splash_local_data_source.dart'
    as _i37;
import '../features/splash/data/data_source/splash_remote_data_source.dart'
    as _i38;
import '../features/splash/domain/repository/splash_repository.dart' as _i39;
import '../features/splash/domain/use_case/get_configuration.dart' as _i66;
import '../features/topic/data/data_source/topic_local_data_source.dart'
    as _i43;
import '../features/topic/data/data_source/topic_remote_data_source.dart'
    as _i44;
import '../features/topic/domain/repository/topic_repository.dart' as _i45;
import '../features/topic/domain/use_case/add_topic.dart' as _i53;
import '../features/topic/domain/use_case/add_topics_to_folder.dart' as _i54;
import '../features/topic/domain/use_case/delete_topic.dart' as _i61;
import '../features/topic/domain/use_case/favorite_vocabulary.dart' as _i63;
import '../features/topic/domain/use_case/get_available_topics.dart' as _i65;
import '../features/topic/domain/use_case/get_recently_learned.dart' as _i69;
import '../features/topic/domain/use_case/get_topic_details.dart' as _i70;
import '../features/topic/domain/use_case/get_user_topics.dart' as _i71;
import '../features/topic/domain/use_case/save_topic_to_local.dart' as _i74;
import '../features/topic/domain/use_case/update_topic.dart' as _i47;
import 'di_config.dart' as _i75;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final appModule = _$AppModule();
  await gh.factoryAsync<_i3.AppPrefs>(
    () => appModule.prefs,
    preResolve: true,
  );
  gh.lazySingleton<_i4.AuthenticationLocalDataSource>(
      () => appModule.authenticationLocalDataSource);
  gh.lazySingleton<_i5.AuthenticationRemoteDataSource>(
      () => appModule.authenticationRemoteDataSource);
  gh.lazySingleton<_i6.AuthenticationRepository>(
      () => appModule.authenticationRepository);
  gh.lazySingleton<_i7.Box<dynamic>>(() => appModule.box);
  gh.lazySingleton<_i8.Connectivity>(() => appModule.connectivity);
  gh.lazySingleton<_i9.CsvToListConverter>(() => appModule.csvToListConverter);
  gh.lazySingleton<_i10.Dio>(() => appModule.dio);
  gh.lazySingleton<_i11.FolderRemoteDataSource>(
      () => appModule.folderRemoteDataSource);
  gh.lazySingleton<_i12.FolderRepository>(() => appModule.folderRepository);
  gh.lazySingleton<_i13.GetAvailableFoldersUseCase>(
      () => _i13.GetAvailableFoldersUseCase(gh<_i12.FolderRepository>()));
  gh.lazySingleton<_i14.GetFolderDetailUseCase>(
      () => _i14.GetFolderDetailUseCase(gh<_i12.FolderRepository>()));
  gh.lazySingleton<_i15.GetUserFoldersUseCase>(
      () => _i15.GetUserFoldersUseCase(gh<_i12.FolderRepository>()));
  gh.lazySingleton<_i16.GoogleSignIn>(() => appModule.googleSignIn);
  gh.lazySingleton<_i17.Helper>(() => _i17.Helper(gh<_i10.Dio>()));
  gh.lazySingleton<_i18.HiveStorage>(
      () => _i18.HiveStorage(gh<_i7.Box<dynamic>>()));
  gh.lazySingleton<_i19.ImagePicker>(() => appModule.imagePicker);
  gh.lazySingleton<_i9.ListToCsvConverter>(() => appModule.listToCsvConverter);
  gh.lazySingleton<_i20.LoginUseCase>(
      () => _i20.LoginUseCase(gh<_i6.AuthenticationRepository>()));
  gh.lazySingleton<_i21.ProfileLocalDataSource>(
      () => appModule.profileLocalDataSource);
  gh.lazySingleton<_i22.ProfileRemoteDataSource>(
      () => appModule.profileRemoteDataSource);
  gh.lazySingleton<_i23.ProfileRepository>(() => appModule.profileRepository);
  gh.lazySingleton<_i24.RankingsRemoteDataSource>(
      () => appModule.rankingsRemoteDataSource);
  gh.lazySingleton<_i25.RankingsRepository>(
      () => _i26.RankingsRepositoryImpl(gh<_i24.RankingsRemoteDataSource>()));
  gh.lazySingleton<_i27.RegistrationUseCase>(
      () => _i27.RegistrationUseCase(gh<_i6.AuthenticationRepository>()));
  gh.lazySingleton<_i28.RemoveFolderUseCase>(
      () => _i28.RemoveFolderUseCase(gh<_i12.FolderRepository>()));
  gh.lazySingleton<_i29.RemoveTopicFromFolderUseCase>(
      () => _i29.RemoveTopicFromFolderUseCase(gh<_i12.FolderRepository>()));
  gh.lazySingleton<_i30.RequestOtpPassword>(
      () => _i30.RequestOtpPassword(gh<_i6.AuthenticationRepository>()));
  gh.lazySingleton<_i31.ResetPassword>(
      () => _i31.ResetPassword(gh<_i6.AuthenticationRepository>()));
  gh.lazySingleton<_i32.SearchRemoteDataSource>(
      () => appModule.searchRemoteDataSource);
  gh.lazySingleton<_i33.SearchRepostory>(
      () => _i34.SearchRepositoryImpl(gh<_i32.SearchRemoteDataSource>()));
  gh.lazySingleton<_i35.SendOtpNewEmailUseCase>(
      () => _i35.SendOtpNewEmailUseCase(gh<_i23.ProfileRepository>()));
  gh.lazySingleton<_i36.SocialLogin>(
      () => _i36.SocialLogin(gh<_i6.AuthenticationRepository>()));
  gh.lazySingleton<_i37.SplashLocalDataSource>(
      () => appModule.splashLocalDataSource);
  gh.lazySingleton<_i38.SplashRemoteDataSource>(
      () => appModule.splashRemoteDataSource);
  gh.lazySingleton<_i39.SplashRepository>(() => appModule.splashRepository);
  gh.lazySingleton<_i40.TopicLearningRemoteDataSource>(
      () => appModule.topicLearningRemoteDataSource);
  gh.lazySingleton<_i41.TopicLearningRepository>(() =>
      _i42.TopicLearningRepositoryImpl(
          gh<_i40.TopicLearningRemoteDataSource>()));
  gh.lazySingleton<_i43.TopicLocalDataSource>(
      () => _i43.TopicLocalDataSourceImpl(gh<_i18.HiveStorage>()));
  gh.lazySingleton<_i44.TopicRemoteDataSource>(
      () => appModule.topicRemoteDataSource);
  gh.lazySingleton<_i45.TopicRepository>(() => appModule.topicRepository);
  gh.lazySingleton<_i46.UpdateLearningStatisticsUseCase>(() =>
      _i46.UpdateLearningStatisticsUseCase(gh<_i41.TopicLearningRepository>()));
  gh.lazySingleton<_i47.UpdateTopicUseCase>(
      () => _i47.UpdateTopicUseCase(gh<_i45.TopicRepository>()));
  gh.lazySingleton<_i48.VerifyNewEmailUseCase>(
      () => _i48.VerifyNewEmailUseCase(gh<_i23.ProfileRepository>()));
  gh.lazySingleton<_i49.VerifyOtp>(
      () => _i49.VerifyOtp(gh<_i6.AuthenticationRepository>()));
  gh.lazySingleton<_i50.VerifyPasswordUseCase>(
      () => _i50.VerifyPasswordUseCase(gh<_i23.ProfileRepository>()));
  gh.lazySingleton<_i51.AddFolderUseCase>(
      () => _i51.AddFolderUseCase(gh<_i12.FolderRepository>()));
  gh.lazySingleton<_i52.AddFoldersToTopicUseCase>(
      () => _i52.AddFoldersToTopicUseCase(gh<_i12.FolderRepository>()));
  gh.lazySingleton<_i53.AddTopicUseCase>(
      () => _i53.AddTopicUseCase(gh<_i45.TopicRepository>()));
  gh.lazySingleton<_i54.AddTopicsToFolderUseCase>(
      () => _i54.AddTopicsToFolderUseCase(gh<_i45.TopicRepository>()));
  gh.lazySingleton<_i55.ChangeDarkMode>(
      () => _i55.ChangeDarkMode(gh<_i23.ProfileRepository>()));
  gh.lazySingleton<_i56.ChangeLanguage>(
      () => _i56.ChangeLanguage(gh<_i23.ProfileRepository>()));
  gh.lazySingleton<_i57.ChangeNameUseCase>(
      () => _i57.ChangeNameUseCase(gh<_i23.ProfileRepository>()));
  gh.lazySingleton<_i58.ChangePasswordUseCase>(
      () => _i58.ChangePasswordUseCase(gh<_i23.ProfileRepository>()));
  gh.lazySingleton<_i59.ChangePushNotification>(
      () => _i59.ChangePushNotification(gh<_i23.ProfileRepository>()));
  gh.lazySingleton<_i60.ChangeSaveOffline>(
      () => _i60.ChangeSaveOffline(gh<_i23.ProfileRepository>()));
  gh.lazySingleton<_i61.DeleteTopicUseCase>(
      () => _i61.DeleteTopicUseCase(gh<_i45.TopicRepository>()));
  gh.lazySingleton<_i62.EditFolderUseCase>(
      () => _i62.EditFolderUseCase(gh<_i12.FolderRepository>()));
  gh.lazySingleton<_i63.FavoriteVocabularyUseCase>(
      () => _i63.FavoriteVocabularyUseCase(gh<_i45.TopicRepository>()));
  gh.lazySingleton<_i64.FetchSearchTopicsUseCase>(
      () => _i64.FetchSearchTopicsUseCase(gh<_i33.SearchRepostory>()));
  gh.lazySingleton<_i65.GetAvailableTopicsUseCase>(
      () => _i65.GetAvailableTopicsUseCase(gh<_i45.TopicRepository>()));
  gh.lazySingleton<_i66.GetConfigurationUseCase>(
      () => _i66.GetConfigurationUseCase(gh<_i39.SplashRepository>()));
  gh.lazySingleton<_i67.GetProfile>(
      () => _i67.GetProfile(gh<_i23.ProfileRepository>()));
  gh.lazySingleton<_i68.GetRankingsUseCase>(
      () => _i68.GetRankingsUseCase(gh<_i25.RankingsRepository>()));
  gh.lazySingleton<_i69.GetRecentlyLearnedUseCase>(
      () => _i69.GetRecentlyLearnedUseCase(gh<_i45.TopicRepository>()));
  gh.lazySingleton<_i70.GetTopicDetailsUseCase>(
      () => _i70.GetTopicDetailsUseCase(gh<_i45.TopicRepository>()));
  gh.lazySingleton<_i71.GetUserTopicUseCase>(
      () => _i71.GetUserTopicUseCase(gh<_i45.TopicRepository>()));
  gh.lazySingleton<_i72.Logout>(
      () => _i72.Logout(gh<_i23.ProfileRepository>()));
  gh.lazySingleton<_i73.PickProfileImage>(
      () => _i73.PickProfileImage(gh<_i23.ProfileRepository>()));
  gh.lazySingleton<_i74.SaveTopicToLocalUseCase>(
      () => _i74.SaveTopicToLocalUseCase(gh<_i45.TopicRepository>()));
  return getIt;
}

class _$AppModule extends _i75.AppModule {}
