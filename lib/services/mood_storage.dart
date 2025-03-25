import 'dart:convert';                           // Para convertir datos a JSON y desde JSON
import 'package:flutter/foundation.dart';        // Para debug/logs en modo desarrollo
import 'package:shared_preferences/shared_preferences.dart';  // Almacenamiento local simple
import '../models/mood_entry.dart';              // Modelo de entrada de estado de ánimo

// Clase estática que gestiona el guardado, carga y limpieza de estados de ánimo
class MoodStorage {
  // Clave utilizada para guardar la lista en SharedPreferences
  static const String key = 'mood_entries';

  // Guarda una nueva entrada en el almacenamiento
  static Future<void> saveMoodEntry(MoodEntry entry) async {
    final prefs = await SharedPreferences.getInstance();

    // Cargamos las entradas ya existentes
    final existing = await loadMoodEntries();

    // Añadimos la nueva entrada
    existing.add(entry);

    // Convertimos cada entrada a formato JSON (como String)
    List<String> encoded = existing.map((e) => jsonEncode(e.toJson())).toList();

    // Guardamos la lista codificada
    await prefs.setStringList(key, encoded);
  }

  // Carga todas las entradas guardadas desde el almacenamiento
  static Future<List<MoodEntry>> loadMoodEntries() async {
    final prefs = await SharedPreferences.getInstance();

    // Obtenemos la lista de Strings guardada, o una lista vacía si no hay nada
    final data = prefs.getStringList(key);
    if (data == null) return [];

    try {
      // Convertimos cada String JSON de vuelta a MoodEntry
      return data
          .map((item) => MoodEntry.fromJson(jsonDecode(item)))
          .toList();
    } catch (e) {
      // Si ocurre algún error al convertir, lo mostramos en consola (solo en modo debug)
      if (kDebugMode) {
        print("❌ Error al cargar datos: $e");
      }
      return [];
    }
  }

  // Borra todos los registros guardados (útil para reiniciar la app o depurar)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
