import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService _shared = SettingsService._sharedInstance();
  SettingsService._sharedInstance();
  factory SettingsService() => _shared;
  late SharedPreferences _preferences;
  bool _isInitialized = false;

  static const String _isConfiguredKey = 'isConfigured';
  static const String _hasPlanKey = 'hasPlan';

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
}
