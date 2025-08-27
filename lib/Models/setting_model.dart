class AppSettings {
  final bool notificationsEnabled;
  final bool darkMode;
  final String language;

  AppSettings({
    required this.notificationsEnabled,
    required this.darkMode,
    required this.language,
  });

  factory AppSettings.defaultSettings() {
    return AppSettings(
      notificationsEnabled: true,
      darkMode: false,
      language: 'English',
    );
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      darkMode: map['darkMode'] ?? false,
      language: map['language'] ?? 'English',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'darkMode': darkMode,
      'language': language,
    };
  }

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? darkMode,
    String? language,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
    );
  }
}