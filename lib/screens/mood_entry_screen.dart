import 'package:flutter/material.dart';
import '../models/mood_entry.dart';         // Modelo de datos para cada estado de ánimo
import '../services/mood_storage.dart';    // Funciones para guardar/cargar desde almacenamiento local

// Pantalla donde el usuario registra su estado de ánimo
class MoodEntryScreen extends StatefulWidget {
  const MoodEntryScreen({super.key});

  @override
  _MoodEntryScreenState createState() => _MoodEntryScreenState();
}

class _MoodEntryScreenState extends State<MoodEntryScreen> {
  int? selectedMoodId; // ID del estado de ánimo seleccionado
  final TextEditingController noteController = TextEditingController(); // Controlador del campo de nota

  // Lista de iconos para representar distintos estados de ánimo (índice = moodId)
  final List<IconData> moodIcons = [
    Icons.sentiment_very_satisfied,    // 0: Muy feliz
    Icons.sentiment_satisfied,         // 1: Contento
    Icons.sentiment_neutral,           // 2: Neutro
    Icons.sentiment_dissatisfied,      // 3: Triste
    Icons.sentiment_very_dissatisfied, // 4: Muy triste
  ];

  // Función para guardar el estado de ánimo
  void saveMood() async {
    if (selectedMoodId == null) {
      // Si no se ha seleccionado ningún estado, mostramos aviso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor selecciona un estado de ánimo')),
      );
      return;
    }

    // Creamos una nueva entrada con los datos actuales
    final newEntry = MoodEntry(
      moodId: selectedMoodId!,
      note: noteController.text,
      date: DateTime.now(),
    );

    // Guardamos la entrada localmente
    await MoodStorage.saveMoodEntry(newEntry);

    // Reiniciamos el formulario
    setState(() {
      selectedMoodId = null;
      noteController.clear();
    });

    // Mostramos mensaje de confirmación
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
            // Pregunta principal
            Text('¿Cómo te sientes hoy?', style: TextStyle(fontSize: 20)),

            SizedBox(height: 20),

            // Selector de estados de ánimo (íconos)
            Wrap(
              spacing: 10,
              children: List.generate(moodIcons.length, (index) {
                return ChoiceChip(
                  label: Icon(moodIcons[index], size: 30), // Icono visible
                  selected: selectedMoodId == index, // Activo si coincide con el seleccionado
                  onSelected: (_) {
                    setState(() {
                      selectedMoodId = index; // Guardamos selección
                    });
                  },
                );
              }),
            ),

            SizedBox(height: 30),

            // Campo de texto para nota opcional
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Escribe una nota (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            SizedBox(height: 20),

            // Botón para guardar
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
