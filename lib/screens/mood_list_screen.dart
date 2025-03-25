import 'package:flutter/material.dart';
import '../models/mood_entry.dart';         // Modelo que representa una entrada de estado de ánimo
import '../services/mood_storage.dart';    // Acceso al almacenamiento local
import '../widgets/mood_card.dart';        // Widget reutilizable para mostrar cada entrada

// Pantalla que muestra el historial completo de entradas registradas
class MoodListScreen extends StatefulWidget {
  const MoodListScreen({super.key});

  @override
  _MoodListScreenState createState() => _MoodListScreenState();
}

class _MoodListScreenState extends State<MoodListScreen> {
  // Lista de entradas cargadas desde almacenamiento
  List<MoodEntry> moodEntries = [];

  @override
  void initState() {
    super.initState();
    loadEntries(); // Al iniciar la pantalla, cargamos los datos
  }

  // Carga las entradas guardadas y actualiza el estado
  Future<void> loadEntries() async {
    final entries = await MoodStorage.loadMoodEntries();
    setState(() {
      // Las invertimos para que las más recientes aparezcan arriba
      moodEntries = entries.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Historial completo')),

      // Si no hay datos, mostramos un mensaje amigable
      body: moodEntries.isEmpty
          ? Center(child: Text('Aún no hay registros 😌'))

      // Si hay entradas, mostramos una lista desplazable
          : ListView.builder(
        itemCount: moodEntries.length, // cuántos ítems mostrar
        itemBuilder: (context, index) {
          // Para cada entrada, mostramos una tarjeta personalizada
          return MoodCard(entry: moodEntries[index]);
        },
      ),
    );
  }
}
