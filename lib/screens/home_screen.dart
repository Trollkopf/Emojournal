import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mood_entry.dart';
import '../services/mood_storage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MoodEntry> recentEntries = [];

  final Map<String, int> moodValues = {
    '😄': 5,
    '😐': 3,
    '😢': 1,
    '😠': 2,
    '😴': 0,
  };

  @override
  void initState() {
    super.initState();
    loadRecentEntries();
  }

  Future<void> loadRecentEntries() async {
    final allEntries = await MoodStorage.loadMoodEntries();
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) => now.subtract(Duration(days: i)));

    final filtered = last7Days.map((day) {
      return allEntries.lastWhere(
            (entry) =>
        entry.date.day == day.day &&
            entry.date.month == day.month &&
            entry.date.year == day.year,
        orElse: () => MoodEntry(emoji: '😐', note: '', date: day),
      );
    }).toList().reversed.toList();

    setState(() {
      recentEntries = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resumen semanal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: recentEntries.isEmpty
            ? Center(child: Text('Sin datos por ahora 😌'))
            : BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 5,
            minY: 0,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= recentEntries.length) {
                      return SizedBox.shrink();
                    }
                    final date = recentEntries[index].date;
                    return Text(
                      '${date.day}/${date.month}',
                      style: TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            barGroups: recentEntries.asMap().entries.map((entry) {
              final index = entry.key;
              final mood = moodValues[entry.value.emoji] ?? 3;
              return BarChartGroupData(x: index, barRods: [
                BarChartRodData(toY: mood.toDouble(), color: Colors.indigo, width: 18),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
