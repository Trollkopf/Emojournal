import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_entry.dart';

class MoodStorage {
  static const String key = 'mood_entries';

  // Guarda la lista en SharedPreferences
  static Future<void> saveMoodEntry(MoodEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await loadMoodEntries();
    existing.add(entry);
    List<String> encoded = existing.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(key, encoded);
  }

  // Carga la lista desde SharedPreferences
  static Future<List<MoodEntry>> loadMoodEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key);
    if (data == null) return [];
    return data
        .map((item) => MoodEntry.fromJson(jsonDecode(item)))
        .toList();
  }
}
