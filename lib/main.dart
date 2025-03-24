import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/mood_list_screen.dart';

void main() {
  runApp(const EmoJournalApp());
}

class EmoJournalApp extends StatelessWidget {
  const EmoJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Mood Diario',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/moods': (context) => MoodListScreen(),
      },
    );
  }
}
