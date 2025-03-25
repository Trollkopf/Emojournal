import 'package:flutter/material.dart';
import '../models/mood_entry.dart';

class MoodCard extends StatelessWidget {
  final MoodEntry entry;

  MoodCard({super.key, required this.entry});

  final List<IconData> moodIcons = [
    Icons.sentiment_very_satisfied,
    Icons.sentiment_satisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_very_dissatisfied,
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          moodIcons[entry.moodId],
          size: 32,
          color: Colors.indigo,
        ),
        title: Text(
          entry.note.isNotEmpty ? entry.note : 'Sin nota',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${entry.date.day}/${entry.date.month}/${entry.date.year}',
        ),
      ),
    );
  }
}
