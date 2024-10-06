import 'dart:convert';

import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/configs/storage/app_prefs.dart';
import 'package:final_flashcard/features/authentication/data/model/user_model.dart';
import 'package:final_flashcard/features/splash/data/model/configuration_model.dart';

abstract class SplashLocalDataSource {
  Future<ConfigurationModel> getConfiguration();
  Future<void> removeToken();
  UserModel? getUser();
  Future<void> removeUser();
}

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  final AppPrefs _appPrefs;

  SplashLocalDataSourceImpl(this._appPrefs);

  @override
  Future<ConfigurationModel> getConfiguration() async {
    final isDarkMode = _appPrefs.getValueForKey(GlobalConstants.kDarkModeKey);
    final isFirstTime = _appPrefs.getValueForKey(GlobalConstants.kFirstTimeKey);
    final language = _appPrefs.getValueForKey(GlobalConstants.kLanguageKey);
    final token = _appPrefs.getToken();

    if (isFirstTime == null) {
      await _appPrefs.setValueForKey(GlobalConstants.kFirstTimeKey, false);
    }

    return Future.value(
      ConfigurationModel(
        isDarkMode: isDarkMode,
        isFirstTime: isFirstTime,
        languageCode: language,
        token: token,
      ),
    );
  }

  @override
  Future<void> removeToken() async {
    await _appPrefs.logout();
  }

  @override
  UserModel? getUser() {
    final userJsonStr = _appPrefs.getUser();
    if (userJsonStr == null || userJsonStr.isEmpty) {
      return null;
    } else {
      return UserModel.fromJson(
        jsonDecode(userJsonStr),
      );
    }
  }

  @override
  Future<void> removeUser() async {
    return await _appPrefs.remove(key: GlobalConstants.kUserKey);
  }
}
