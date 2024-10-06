class GetConfigResponse {
  final bool? darkMode;
  final String? language;

  GetConfigResponse({
    this.darkMode,
    this.language,
  });

  factory GetConfigResponse.fromJson(Map<String, dynamic> json) {
    return GetConfigResponse(
      darkMode: json['darkMode'],
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'language': language,
    };
  }
}
