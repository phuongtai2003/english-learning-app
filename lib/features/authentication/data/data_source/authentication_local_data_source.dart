import 'dart:convert';

import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/configs/storage/app_prefs.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/features/authentication/data/model/user_model.dart';

abstract class AuthenticationLocalDataSource {
  Future<void> saveEmailAndPassword(String email, String password);
  Future<DataMap> getEmailAndPassword();
  Future<void> saveToken(String token);
  Future<void> saveUser(UserModel user);
}

class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  final AppPrefs _appPrefs;

  AuthenticationLocalDataSourceImpl(this._appPrefs);

  @override
  Future<void> saveEmailAndPassword(String email, String password) async {
    await _appPrefs.saveLoginInput(email: email, password: password);
  }

  @override
  Future<DataMap> getEmailAndPassword() async {
    final email = await _appPrefs.getValueForKey(GlobalConstants.kEmailKey);
    final password =
        await _appPrefs.getValueForKey(GlobalConstants.kPasswordKey);
    return {
      GlobalConstants.kEmailKey: email,
      GlobalConstants.kPasswordKey: password,
    };
  }

  @override
  Future<void> saveToken(String token) async {
    await _appPrefs.setToken(token);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await _appPrefs.setUser(
      jsonEncode(
        user.toJson(),
      ),
    );
  }
}
