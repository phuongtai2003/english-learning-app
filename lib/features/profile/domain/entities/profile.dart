class Profile {
  final int? id;
  final String? email;
  final String? name;
  final DateTime? dateOfBirth;
  final bool? darkMode;
  final String? language;
  final bool? pushNotification;
  final bool? saveSets;
  final String? image;

  const Profile({
    required this.id,
    required this.email,
    required this.name,
    required this.dateOfBirth,
    required this.darkMode,
    required this.language,
    required this.pushNotification,
    required this.saveSets,
    required this.image,
  });

  Profile copyWith({
    int? id,
    String? email,
    String? name,
    DateTime? dateOfBirth,
    bool? darkMode,
    String? language,
    bool? pushNotification,
    bool? saveSets,
    String? image,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      pushNotification: pushNotification ?? this.pushNotification,
      saveSets: saveSets ?? this.saveSets,
      image: image ?? this.image,
    );
  }
}
