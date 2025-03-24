import 'package:flutter/material.dart';
import '../models/mood_entry.dart';

class MoodCard extends StatelessWidget {
  final MoodEntry entry;

  const MoodCard({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Text(
          entry.emoji,
          style: const TextStyle(fontSize: 30),
        ),
        title: Text(
          entry.note.isNotEmpty ? entry.note : 'Sin nota',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${entry.date.day}/${entry.date.month}/${entry.date.year}',
        ),
      ),
    );
  }
}
