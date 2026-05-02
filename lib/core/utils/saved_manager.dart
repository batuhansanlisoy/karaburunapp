import 'package:shared_preferences/shared_preferences.dart';

class SavedManager {
  static const String orgKey = 'saved_orgs';
  static const String beachKey = 'saved_beaches';
  static const String placeKey = 'saved_places';
  static const String activityKey = 'saved_activities';
  static const String localProducerKey = 'saved_local_producers';

  static Future<List<int>> getSavedIds(String categoryKey) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> stringList = prefs.getStringList(categoryKey) ?? [];
    
    return stringList.map((e) => int.parse(e)).toList();
  }

  static Future<bool> toggleSave(String categoryKey, int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentList = prefs.getStringList(categoryKey) ?? [];
    
    String idStr = id.toString();

    if (currentList.contains(idStr)) {
      currentList.remove(idStr);
    } else {
      currentList.add(idStr);
    }

    return await prefs.setStringList(categoryKey, currentList);
  }

  static Future<bool> isSaved(String categoryKey, int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentList = prefs.getStringList(categoryKey) ?? [];
    return currentList.contains(id.toString());
  }
}