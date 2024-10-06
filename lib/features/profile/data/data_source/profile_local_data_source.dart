import 'dart:convert';

import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/configs/storage/app_prefs.dart';
import 'package:final_flashcard/configs/storage/hive_storage.dart';
import 'package:final_flashcard/core/errors/failure.dart';
import 'package:final_flashcard/features/profile/data/model/get_config_response.dart';
import 'package:final_flashcard/features/profile/data/model/profile_model.dart';

abstract class ProfileLocalDataSource {
  const ProfileLocalDataSource();

  Future<void> logout();
  Future<void> changeDarkMode(bool darkMode);
  Future<GetConfigResponse> getConfig();
  Future<void> changeLanguage(String language);
  Future<void> saveToken(String token);
  Future<ProfileModel> getLocalUser();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final AppPrefs _appPrefs;
  final HiveStorage _hiveStorage;

  const ProfileLocalDataSourceImpl(this._appPrefs, this._hiveStorage);

  @override
  Future<void> logout() async {
    await _hiveStorage.clearData();
    await _appPrefs.logout();
  }

  @override
  Future<void> changeDarkMode(bool darkMode) async {
    await _appPrefs.setValueForKey(GlobalConstants.kDarkModeKey, darkMode);
  }

  @override
  Future<GetConfigResponse> getConfig() async {
    final darkMode = _appPrefs.getValueForKey<bool?>(
      GlobalConstants.kDarkModeKey,
    );
    final language = _appPrefs.getValueForKey<String?>(
      GlobalConstants.kLanguageKey,
    );
    return GetConfigResponse(
      darkMode: darkMode,
      language: language,
    );
  }

  @override
  Future<void> changeLanguage(String language) async {
    await _appPrefs.setValueForKey(
      GlobalConstants.kLanguageKey,
      language,
    );
  }

  @override
  Future<void> saveToken(String token) async {
    await _appPrefs.setToken(
      token,
    );
  }

  @override
  Future<ProfileModel> getLocalUser() {
    final userJsonStr = _appPrefs.getUser();
    if (userJsonStr == null || userJsonStr.isEmpty) {
      throw const CacheFailure(message: 'something_went_wrong', statusCode: 0);
    } else {
      return Future.value(
        ProfileModel.fromJson(
          jsonDecode(userJsonStr),
        ),
      );
    }
  }
}
