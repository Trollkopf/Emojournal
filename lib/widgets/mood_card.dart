import 'package:flutter/material.dart';
import '../models/mood_entry.dart';  // Importa el modelo que representa una entrada de estado de ánimo

// Widget reutilizable que representa una "tarjeta" con la información de una entrada emocional
class MoodCard extends StatelessWidget {
  final MoodEntry entry;  // Entrada a mostrar (pasada desde la lista)

  // Constructor que recibe una entrada obligatoria
  MoodCard({super.key, required this.entry});

  // Lista de iconos asociados a cada estado de ánimo (por índice/moodId)
  final List<IconData> moodIcons = [
    Icons.sentiment_very_satisfied,    // 0 - Muy feliz
    Icons.sentiment_satisfied,         // 1 - Feliz
    Icons.sentiment_neutral,           // 2 - Neutro
    Icons.sentiment_dissatisfied,      // 3 - Triste
    Icons.sentiment_very_dissatisfied, // 4 - Muy triste
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12), // Espaciado exterior
      elevation: 2, // Sombra de la tarjeta
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Bordes redondeados

      // Contenido principal de la tarjeta
      child: ListTile(
        // Icono que representa el estado de ánimo
        leading: Icon(
          moodIcons[entry.moodId], // Seleccionamos el icono según el moodId
          size: 32,
          color: Colors.indigo,
        ),

        // Nota escrita por el usuario (o "Sin nota" si está vacía)
        title: Text(
          entry.note.isNotEmpty ? entry.note : 'Sin nota',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        // Fecha en que se registró la entrada
        subtitle: Text(
          '${entry.date.day}/${entry.date.month}/${entry.date.year}',
        ),
      ),
    );
  }
}
