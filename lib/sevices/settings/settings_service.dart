import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService _shared = SettingsService._sharedInstance();
  SettingsService._sharedInstance();
  factory SettingsService() => _shared;
  late SharedPreferences _preferences;
  bool _isInitialized = false;

  static const String _isConfiguredKey = 'isConfigured';
  static const String _hasPlanKey = 'hasPlan';
  static const String _planEndingDigitDateKey = 'planEndingDigitDate';
  static const String _isDarkModeKey = 'isDarkMode';
  static const String _languageKey = 'language';
  static const String _weightUnitKey = 'weightUnit';

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw Exception(
          "SettingsService has not been initialized. Call init() first.");
    }
  }

  Future<void> setAppConfiguredFlag(bool value) async {
    _ensureInitialized();
    await _preferences.setBool(_isConfiguredKey, value);
  }

  bool isAppConfiguredFlag() {
    _ensureInitialized();
    return _preferences.getBool(_isConfiguredKey) ?? false;
  }

  Future<void> setHasPlanFlag(bool value) async {
    _ensureInitialized();
    await _preferences.setBool(_hasPlanKey, value);
  }

  bool hasPlanFlag() {
    _ensureInitialized();
    return _preferences.getBool(_hasPlanKey) ?? false;
  }

  Future<void> setPlanEndingDigitDate(String value) async {
    _ensureInitialized();
    await _preferences.setString(_planEndingDigitDateKey, value);
  }

  String? planEndingDigitDate() {
    _ensureInitialized();
    return _preferences.getString(_planEndingDigitDateKey);
  }

  Future<void> setIsDarkModeFlag(bool value) async {
    _ensureInitialized();
    await _preferences.setBool(_isDarkModeKey, value);
  }

  bool isDarkModeFlag() {
    _ensureInitialized();
    return _preferences.getBool(_isDarkModeKey) ?? false;
  }

  Future<void> setLanguage(String value) async {
    _ensureInitialized();
    await _preferences.setString(_languageKey, value);
  }

  String? language() {
    _ensureInitialized();
    return _preferences.getString(_languageKey);
  }

  Future<void> setWeightUnit(String value) async {
    _ensureInitialized();
    await _preferences.setString(_weightUnitKey, value);
  }

  String? weightUnit() {
    _ensureInitialized();
    return _preferences.getString(_weightUnitKey);
  }
}
