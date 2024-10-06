import 'package:equatable/equatable.dart';

class Configuration extends Equatable {
  final bool? isDarkMode;
  final String? languageCode;
  final bool? isFirstTime;
  final String? token;

  const Configuration({
    this.isDarkMode,
    this.languageCode,
    this.isFirstTime,
    this.token,
  });

  @override
  List<Object?> get props => [
        isDarkMode,
        languageCode,
        isFirstTime,
        token,
      ];

  Configuration copyWith({
    bool? isDarkMode,
    String? languageCode,
    bool? isFirstTime,
    String? token,
  }) {
    return Configuration(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      languageCode: languageCode ?? this.languageCode,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      token: token ?? this.token,
    );
  }
}
