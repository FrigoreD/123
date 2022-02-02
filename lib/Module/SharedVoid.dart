
import 'package:shared_preferences/shared_preferences.dart';

class SharedVoid {
  static Future<String> getValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String answer= prefs.getString(key);

    return answer;
  }
}