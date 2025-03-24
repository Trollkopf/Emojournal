class MoodEntry {
  final String emoji;
  final String note;
  final DateTime date;

  MoodEntry({
    required this.emoji,
    required this.note,
    required this.date,
  });

  // Para guardar como JSON
  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  // Para leer desde JSON
  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      emoji: json['emoji'],
      note: json['note'],
      date: DateTime.parse(json['date']),
    );
  }
}
