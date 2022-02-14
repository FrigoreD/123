
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class SharedVoid {
  static Future<String> getValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String answer= prefs.getString(key);

    return answer;
  }
}