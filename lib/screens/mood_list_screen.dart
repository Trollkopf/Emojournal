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
      moodEntries = entries.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Historial completo')),
      body: moodEntries.isEmpty
          ? Center(child: Text('Aún no hay registros 😌'))
          : ListView.builder(
        itemCount: moodEntries.length,
        itemBuilder: (context, index) {
          return MoodCard(entry: moodEntries[index]);
        },
      ),
    );
  }
}
