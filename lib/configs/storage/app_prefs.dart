import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/configs/storage/base_prefs.dart';

class AppPrefs extends BasePrefs {
  Future<AppPrefs> initialize() async {
    final prefs = AppPrefs();
    await prefs.init();
    return prefs;
  }

  Future<void> setToken(String? token) async {
    await setValueForKey(GlobalConstants.kTokenKey, token);
  }

  String? getToken() {
    return getValueForKey(GlobalConstants.kTokenKey);
  }

  Future<void> setUser(String? user) async {
    await setValueForKey(GlobalConstants.kUserKey, user);
  }

  String? getUser() {
    return getValueForKey(GlobalConstants.kUserKey);
  }

  Future<void> saveLoginInput(
      {required String email, required String password}) async {
    await setValueForKey(GlobalConstants.kEmailKey, email);
    await setValueForKey(GlobalConstants.kPasswordKey, password);
  }

  Future<void> logout() async {
    await remove(key: GlobalConstants.kTokenKey);
    await remove(key: GlobalConstants.kUserKey);
  }
}
