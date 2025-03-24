import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/mood_storage.dart';
import '../widgets/mood_card.dart';

class MoodListScreen extends StatefulWidget {
  const MoodListScreen({super.key});

  @override
  _MoodListScreenState createState() => _MoodListScreenState();
}

class _MoodListScreenState extends State<MoodListScreen> {
  List<MoodEntry> moodEntries = [];

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  Future<void> loadEntries() async {
    final entries = await MoodStorage.loadMoodEntries();
    setState(() {
      moodEntries = entries.reversed.toList(); // últimos primero
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de estados de ánimo'),
      ),
      body: moodEntries.isEmpty
          ? const Center(child: Text('Aún no hay registros 😌'))
          : ListView.builder(
        itemCount: moodEntries.length,
        itemBuilder: (context, index) {
          final entry = moodEntries[index];
          return MoodCard(entry: entry);
        },
      ),
    );
  }
}

