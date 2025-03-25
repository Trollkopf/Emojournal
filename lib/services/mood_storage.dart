import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_entry.dart';

class MoodStorage {
  static const String key = 'mood_entries';

  static Future<void> saveMoodEntry(MoodEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await loadMoodEntries();
    existing.add(entry);
    List<String> encoded = existing.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(key, encoded);
  }

  static Future<List<MoodEntry>> loadMoodEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key);
    if (data == null) return [];
    try {
      return data
          .map((item) => MoodEntry.fromJson(jsonDecode(item)))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error al cargar datos: $e");
      }
      return [];
    }
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
