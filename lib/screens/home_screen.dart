import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mood_entry.dart';
import '../services/mood_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MoodEntry> recentEntries = [];
  int selectedDays = 7;

  final List<int> moodScores = [5, 4, 3, 2, 1];
  final List<IconData> moodIcons = [
    Icons.sentiment_very_satisfied,    // 0
    Icons.sentiment_satisfied,         // 1
    Icons.sentiment_neutral,           // 2
    Icons.sentiment_dissatisfied,      // 3
    Icons.sentiment_very_dissatisfied, // 4
  ];

  @override
  void initState() {
    super.initState();
    loadRecentEntries();
  }

  Future<void> loadRecentEntries() async {
    final allEntries = await MoodStorage.loadMoodEntries();
    final now = DateTime.now();
    final lastDays = List.generate(selectedDays, (i) => now.subtract(Duration(days: i)));

    final filtered = lastDays.map((day) {
      return allEntries.lastWhere(
            (entry) =>
        entry.date.day == day.day &&
            entry.date.month == day.month &&
            entry.date.year == day.year,
        orElse: () => MoodEntry(moodId: 2, note: '', date: day), // moodId 2 = neutral
      );
    }).toList().reversed.toList();

    setState(() {
      recentEntries = filtered;
    });
  }

  String interpretWeek() {
    final values = recentEntries.map((e) => moodScores[e.moodId]).toList();
    final avg = values.reduce((a, b) => a + b) / values.length;

    String periodLabel;
    switch (selectedDays) {
      case 7:
        periodLabel = "Semana";
        break;
      case 15:
        periodLabel = "Quincena";
        break;
      case 30:
        periodLabel = "Mes";
        break;
      default:
        periodLabel = "$selectedDays días";
    }

    String genere;
    if (selectedDays == 30){
      genere = "o";
    } else {
      genere = "a";
    }

    String moodText;
    if (avg >= 4.5) {
      moodText = "$periodLabel muy positiv$genere 😄";
    } else if (avg >= 3.5) {
      moodText = "$periodLabel alegre 🙂";
    } else if (avg >= 2.5) {
      moodText = "$periodLabel estable 😐";
    } else if (avg >= 1.5) {
      moodText = "$periodLabel bajit$genere 😕";
    } else {
      moodText = "Semana difícil 😢";
    }

    int maxIndex = 0;
    int minIndex = 0;
    for (int i = 1; i < values.length; i++) {
      if (values[i] > values[maxIndex]) maxIndex = i;
      if (values[i] < values[minIndex]) minIndex = i;
    }

    final best = recentEntries[maxIndex].date;
    final worst = recentEntries[minIndex].date;

    String format(DateTime d) => '${d.day}/${d.month}';

    return '''
$moodText
📈 Mejor día: ${format(best)}
📉 Peor día: ${format(worst)}
''';
  }

  Future<String> compareWithPreviousPeriod() async {
    final allEntries = await MoodStorage.loadMoodEntries();

    final now = DateTime.now();
    final currentPeriod = List.generate(selectedDays, (i) => now.subtract(Duration(days: i)));
    final previousPeriod = List.generate(selectedDays, (i) => now.subtract(Duration(days: i + selectedDays)));

    double avgScore(List<DateTime> days) {
      final entries = days.map((day) {
        return allEntries.lastWhere(
              (entry) =>
          entry.date.day == day.day &&
              entry.date.month == day.month &&
              entry.date.year == day.year,
          orElse: () => MoodEntry(moodId: 2, note: '', date: day),
        );
      }).toList();

      final scores = entries.map((e) => moodScores[e.moodId]).toList();
      return scores.reduce((a, b) => a + b) / scores.length;
    }

    final currentAvg = avgScore(currentPeriod);
    final previousAvg = avgScore(previousPeriod);

    if ((currentAvg - previousAvg).abs() < 0.3) {
      return "Has mantenido tu estado emocional estable 🔄";
    } else if (currentAvg > previousAvg) {
      return "Has mejorado respecto al periodo anterior 💪";
    } else {
      return "Tus emociones bajaron un poco respecto al periodo anterior 😕";
    }
  }




  @override
  Widget build(BuildContext context) {
    final moodValues = recentEntries.map((e) => moodScores[e.moodId]).toList();

    if (recentEntries.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Resumen')),
        body: Center(child: Text('Sin datos por ahora 😌')),
      );
    }

    final maxIndex = moodValues.indexOf(moodValues.reduce((a, b) => a > b ? a : b));
    final minIndex = moodValues.indexOf(moodValues.reduce((a, b) => a < b ? a : b));

    return Scaffold(
      appBar: AppBar(title: Text('Resumen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: Column(
            key: ValueKey(selectedDays),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Rango: ', style: TextStyle(fontSize: 14)),
                  DropdownButton<int>(
                    value: selectedDays,
                    items: [7, 15, 30].map((days) {
                      return DropdownMenuItem(
                        value: days,
                        child: Text('$days días'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedDays = value;
                        });
                        loadRecentEntries();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                interpretWeek(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              FutureBuilder(
                future: compareWithPreviousPeriod(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox.shrink();
                  } else if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        snapshot.data!,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 5,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= recentEntries.length) return SizedBox.shrink();
                            final date = recentEntries[index].date;
                            return Text('${date.day}/${date.month}', style: TextStyle(fontSize: 10));
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: List.generate(recentEntries.length, (i) {
                          return FlSpot(i.toDouble(), moodValues[i].toDouble());
                        }),
                        color: Colors.indigo,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            if (index == maxIndex) {
                              return FlDotCirclePainter(
                                radius: 6,
                                color: Colors.green,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            } else if (index == minIndex) {
                              return FlDotCirclePainter(
                                radius: 6,
                                color: Colors.red,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            } else {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: Colors.indigo,
                                strokeWidth: 0,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
