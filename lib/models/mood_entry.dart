class MoodEntry {
  final int moodId;
  final String note;
  final DateTime date;

  MoodEntry({
    required this.moodId,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'moodId': moodId,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      moodId: json['moodId'],
      note: json['note'],
      date: DateTime.parse(json['date']),
    );
  }
}
