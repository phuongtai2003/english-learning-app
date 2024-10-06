import 'package:final_flashcard/core/data/typedef.dart';
import 'package:get/get.dart';

class GlobalConstants {
  static const String appName = 'Leaf';
  static const String baseUrl = 'http://192.168.1.6:8080/api/';
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String passwordRegex =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  static const String nameRegex = r'^[a-zA-Z0-9]{3,}$';
  static const String appIconTag = 'APP_ICON';
  static const String kTokenKey = 'TOKEN';
  static const String kUserKey = 'USER';
  static const String kEmailKey = 'EMAIL';
  static const String kPasswordKey = 'PASSWORD';
  static const String kDarkModeKey = 'DARK_MODE';
  static const String kLanguageKey = 'LANGUAGE';
  static const String kFirstTimeKey = 'FIRST_TIME';
  static const String kSaveSetsKey = 'SAVE_SETS';
  static const String kPushNotificationKey = 'PUSH_NOTIFICATION';
  static const String kDefaultAvatarUrl =
      'https://res.cloudinary.com/dhpxifsfm/image/upload/v1707063140/kr2myrxxfbsa9lxtuqlc.png';
  static DataMap topicLanguages = {
    'af': 'Afrikaans'.tr,
    'ar': 'Arabic'.tr,
    'be': 'Belarusian'.tr,
    'bg': 'Bulgarian'.tr,
    'bn': 'Bengali'.tr,
    'ca': 'Catalan'.tr,
    'cs': 'Czech'.tr,
    'cy': 'Welsh'.tr,
    'da': 'Danish'.tr,
    'de': 'German'.tr,
    'el': 'Greek'.tr,
    'en': 'English'.tr,
    'eo': 'Esperanto'.tr,
    'es': 'Spanish'.tr,
    'et': 'Estonian'.tr,
    'fa': 'Persian'.tr,
    'fi': 'Finnish'.tr,
    'fr': 'French'.tr,
    'ga': 'Irish'.tr,
    'gl': 'Galician'.tr,
    'gu': 'Gujarati'.tr,
    'he': 'Hebrew'.tr,
    'hi': 'Hindi'.tr,
    'hr': 'Croatian'.tr,
    'ht': 'Haitian'.tr,
    'hu': 'Hungarian'.tr,
    'id': 'Indonesian'.tr,
    'is': 'Icelandic'.tr,
    'it': 'Italian'.tr,
    'ja': 'Japanese'.tr,
    'ka': 'Georgian'.tr,
    'kn': 'Kannada'.tr,
    'ko': 'Korean'.tr,
    'lt': 'Lithuanian'.tr,
    'lv': 'Latvian'.tr,
    'mk': 'Macedonian'.tr,
    'mr': 'Marathi'.tr,
    'ms': 'Malay'.tr,
    'mt': 'Maltese'.tr,
    'nl': 'Dutch'.tr,
    'no': 'Norwegian'.tr,
    'pl': 'Polish'.tr,
    'pt': 'Portuguese'.tr,
    'ro': 'Romanian'.tr,
    'ru': 'Russian'.tr,
    'sk': 'Slovak'.tr,
    'sl': 'Slovenian'.tr,
    'sq': 'Albanian'.tr,
    'sv': 'Swedish'.tr,
    'sw': 'Swahili'.tr,
    'ta': 'Tamil'.tr,
    'te': 'Telugu'.tr,
    'th': 'Thai'.tr,
    'tl': 'Tagalog'.tr,
    'tr': 'Turkish'.tr,
    'uk': 'Ukrainian'.tr,
    'ur': 'Urdu'.tr,
    'vi': 'Vietnamese'.tr,
    'zh': 'Chinese'.tr
  };
}
