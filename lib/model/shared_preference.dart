import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  Future createCache(String email, String password) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString("email", email);
    _preferences.setString("password", password);
  }

  Future readCache(String email) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var cache = _preferences.getString("email");
    return cache;
  }

  Future removeCache(String email, String password) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove("email");
    _preferences.remove("password");
  }
}
