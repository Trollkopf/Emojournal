import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/mood_storage.dart';

class MoodEntryScreen extends StatefulWidget {
  @override
  _MoodEntryScreenState createState() => _MoodEntryScreenState();
}

class _MoodEntryScreenState extends State<MoodEntryScreen> {
  String? selectedMood;
  final TextEditingController noteController = TextEditingController();

  final List<String> moods = ['😄', '😐', '😢', '😠', '😴'];

  void saveMood() async {
    if (selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor selecciona un estado de ánimo')),
      );
      return;
    }

    final newEntry = MoodEntry(
      emoji: selectedMood!,
      note: noteController.text,
      date: DateTime.now(),
    );

    await MoodStorage.saveMoodEntry(newEntry);

    setState(() {
      selectedMood = null;
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
              children: moods.map((mood) {
                return ChoiceChip(
                  label: Text(mood, style: TextStyle(fontSize: 24)),
                  selected: selectedMood == mood,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedMood = selected ? mood : null;
                    });
                  },
                );
              }).toList(),
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
