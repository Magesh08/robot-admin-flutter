import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _tokenKey = 'auth_token';
  static const _expiryKey = 'auth_token_expiry';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);

    // Expiry after 5 hours
    final expiryTime = DateTime.now().add(Duration(hours: 5)).toIso8601String();
    await prefs.setString(_expiryKey, expiryTime);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final expiry = prefs.getString(_expiryKey);
    if (expiry != null &&
        DateTime.tryParse(expiry)?.isAfter(DateTime.now()) == true) {
      return prefs.getString(_tokenKey);
    }
    return null;
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_expiryKey);
  }
}
