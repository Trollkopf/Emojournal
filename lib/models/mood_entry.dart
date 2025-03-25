// Clase que representa una entrada de estado de ánimo registrada por el usuario
class MoodEntry {
  final int moodId;      // Índice del estado de ánimo (0 a 4, corresponde a un icono)
  final String note;     // Nota opcional escrita por el usuario
  final DateTime date;   // Fecha en que se guardó esta entrada

  // Constructor con parámetros obligatorios
  MoodEntry({
    required this.moodId,
    required this.note,
    required this.date,
  });

  // Convierte esta instancia en un mapa (formato JSON) para guardarla
  Map<String, dynamic> toJson() {
    return {
      'moodId': moodId,
      'note': note,
      'date': date.toIso8601String(), // Guardamos la fecha como string legible
    };
  }

  // Crea una instancia de MoodEntry a partir de un mapa (por ejemplo, cargado desde JSON)
  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      moodId: json['moodId'],
      note: json['note'],
      date: DateTime.parse(json['date']), // Convertimos el string a objeto DateTime
    );
  }
}
