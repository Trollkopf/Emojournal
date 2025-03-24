import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/mood_storage.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedMood;
  final TextEditingController noteController = TextEditingController();

  final List<String> moods = ['😄', '😐', '😢', '😠', '😴'];

  void saveMood() async {
    if (selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un estado de ánimo')),
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
      const SnackBar(content: Text('Estado de ánimo guardado')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emojournal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, '/moods');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '¿Cómo te sientes hoy?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: moods.map((mood) {
                return ChoiceChip(
                  label: Text(mood, style: const TextStyle(fontSize: 24)),
                  selected: selectedMood == mood,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedMood = selected ? mood : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Escribe una nota (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: saveMood,
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
