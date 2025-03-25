import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/mood_storage.dart';

class MoodEntryScreen extends StatefulWidget {
  const MoodEntryScreen({super.key});

  @override
  _MoodEntryScreenState createState() => _MoodEntryScreenState();
}

class _MoodEntryScreenState extends State<MoodEntryScreen> {
  int? selectedMoodId;
  final TextEditingController noteController = TextEditingController();

  final List<IconData> moodIcons = [
    Icons.sentiment_very_satisfied,    // 0
    Icons.sentiment_satisfied,         // 1
    Icons.sentiment_neutral,           // 2
    Icons.sentiment_dissatisfied,      // 3
    Icons.sentiment_very_dissatisfied, // 4
  ];

  void saveMood() async {
    if (selectedMoodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor selecciona un estado de ánimo')),
      );
      return;
    }

    final newEntry = MoodEntry(
      moodId: selectedMoodId!,
      note: noteController.text,
      date: DateTime.now(),
    );

    await MoodStorage.saveMoodEntry(newEntry);

    setState(() {
      selectedMoodId = null;
      noteController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Estado de ánimo guardado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Añadir estado de ánimo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('¿Cómo te sientes hoy?', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: List.generate(moodIcons.length, (index) {
                return ChoiceChip(
                  label: Icon(moodIcons[index], size: 30),
                  selected: selectedMoodId == index,
                  onSelected: (_) {
                    setState(() {
                      selectedMoodId = index;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 30),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Escribe una nota (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: saveMood,
              icon: Icon(Icons.save),
              label: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
