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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(moodIcons.length, (index) {
                return Flexible(
                  child: ChoiceChip(
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Icon(moodIcons[index], size: 30),
                    ),
                    selected: selectedMoodId == index,
                    onSelected: (_) {
                      setState(() {
                        selectedMoodId = index;
                      });
                    },
                  ),
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
            // ZONA DE PRUEBAS
            SizedBox(height: 40),
            Divider(),
            Text(
              '⚠️ Zona de pruebas (solo para desarrollo)',
              style: TextStyle(fontSize: 14, color: Colors.redAccent),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade800,
              ),
              icon: Icon(Icons.delete_forever),
              label: Text('Borrar todos los registros'),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('¿Seguro que quieres borrar todo?'),
                    content: Text('Esta acción eliminará todos los registros guardados.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar')),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Sí, borrar')),
                    ],
                  ),
                );

                if (confirm == true) {
                  await MoodStorage.clearAll();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Todos los datos han sido eliminados.')),
                  );
                }
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade100,
                foregroundColor: Colors.indigo,
              ),
              icon: Icon(Icons.data_usage),
              label: Text('Generar datos de prueba (30 días)'),
              onPressed: () async {
                await MoodStorage.generateDummyData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Se han generado datos de prueba para los últimos 30 días.')),
                );
              },
            ),


          ],

        ),

      ),

    );
  }
}
