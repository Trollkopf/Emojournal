import 'package:flutter/material.dart';
import 'home_screen.dart';          // Pantalla principal con resumen gráfico
import 'mood_entry_screen.dart';   // Pantalla para registrar un nuevo estado de ánimo
import 'mood_list_screen.dart';    // Pantalla para ver el historial completo

// MainScreen es el contenedor principal con navegación inferior (BottomNavigationBar)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Índice actual seleccionado en la barra de navegación (por defecto: 0)
  int _currentIndex = 0;

  // Lista de pantallas que se pueden mostrar según el índice
  final List<Widget> _screens = [
    HomeScreen(),         // Índice 0 → Resumen gráfico
    MoodEntryScreen(),    // Índice 1 → Formulario de entrada
    MoodListScreen(),     // Índice 2 → Historial
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Muestra la pantalla correspondiente al índice seleccionado
      body: _screens[_currentIndex],

      // Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,             // índice actual activo
        selectedItemColor: Colors.indigo,        // color del icono activo
        unselectedItemColor: Colors.grey,        // color del resto de iconos

        // Cuando el usuario toca un icono, actualizamos el índice y recargamos la pantalla
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        // Elementos (botones) de la barra
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Resumen',   // Pantalla de análisis y gráfica
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Añadir',    // Pantalla para registrar nuevo estado
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial', // Pantalla de entradas anteriores
          ),
        ],
      ),
    );
  }
}
