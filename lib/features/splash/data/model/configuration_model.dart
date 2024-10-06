import 'package:final_flashcard/features/splash/domain/entities/configuration.dart';

class ConfigurationModel extends Configuration {
  const ConfigurationModel({
    bool? isDarkMode,
    String? languageCode,
    bool? isFirstTime,
    String? token,
  }) : super(
          isDarkMode: isDarkMode,
          languageCode: languageCode,
          isFirstTime: isFirstTime,
          token: token,
        );

  factory ConfigurationModel.fromJson(Map<String, dynamic> json) {
    return ConfigurationModel(
      isDarkMode: json['isDarkMode'],
      languageCode: json['languageCode'],
      isFirstTime: json['isFirstTime'],
      token: json['token'],
    );
  }
  factory ConfigurationModel.fromEntity(Configuration entity) {
    return ConfigurationModel(
      isDarkMode: entity.isDarkMode,
      languageCode: entity.languageCode,
      isFirstTime: entity.isFirstTime,
      token: entity.token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'languageCode': languageCode,
      'isFirstTime': isFirstTime,
      'token': token,
    };
  }
}
