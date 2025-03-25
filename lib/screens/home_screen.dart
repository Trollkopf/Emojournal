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
  // Lista con los estados de ánimo del periodo seleccionado
  List<MoodEntry> recentEntries = [];

  // Días seleccionados (7, 15 o 30)
  int selectedDays = 7;

  // Valores numéricos asociados a cada icono de estado de ánimo
  final List<int> moodScores = [5, 4, 3, 2, 1];

  // Lista de iconos de estado de ánimo (índice = moodId)
  final List<IconData> moodIcons = [
    Icons.sentiment_very_satisfied,
    Icons.sentiment_satisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_very_dissatisfied,
  ];

  @override
  void initState() {
    super.initState();
    loadRecentEntries(); // cargamos los últimos estados de ánimo al iniciar
  }

  // Cargar los últimos estados de ánimo según los días seleccionados
  Future<void> loadRecentEntries() async {
    final allEntries = await MoodStorage.loadMoodEntries();
    final now = DateTime.now();

    // Genera una lista de fechas (hoy, ayer, etc.)
    final lastDays = List.generate(selectedDays, (i) => now.subtract(Duration(days: i)));

    // Para cada día, busca si hay un registro guardado. Si no, asigna estado neutral (moodId 2)
    final filtered = lastDays.map((day) {
      return allEntries.lastWhere(
            (entry) =>
        entry.date.day == day.day &&
            entry.date.month == day.month &&
            entry.date.year == day.year,
        orElse: () => MoodEntry(moodId: 2, note: '', date: day), // neutral por defecto
      );
    }).toList().reversed.toList(); // reversa para ordenarlo del más antiguo al más reciente

    setState(() {
      recentEntries = filtered;
    });
  }

  // Analiza cómo ha sido el periodo actual (media, mejor y peor día)
  Widget interpretWeek() {
    // Convertimos los moodId en valores numéricos
    final values = recentEntries.map((e) => moodScores[e.moodId]).toList();
    final avg = values.reduce((a, b) => a + b) / values.length;

    // Etiqueta del periodo (semana, quincena o mes)
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

    // Ajusta la letra final (positivA o positivO)
    String genere = (selectedDays == 30) ? "o" : "a";

    // Texto interpretado según la media
    String moodText;
    if (avg >= 4.5) {
      moodText = "$periodLabel muy positiv$genere 😄";
    } else if (avg >= 3.5) {
      moodText = "$periodLabel alegre 😀";
    } else if (avg >= 2.5) {
      moodText = "$periodLabel estable 🙂";
    } else if (avg >= 1.5) {
      moodText = "$periodLabel bajit$genere 😕";
    } else {
      moodText = "$periodLabel difícil 😢";
    }

    // Buscar mejor y peor día
    int maxIndex = 0;
    int minIndex = 0;
    for (int i = 1; i < values.length; i++) {
      if (values[i] > values[maxIndex]) maxIndex = i;
      if (values[i] < values[minIndex]) minIndex = i;
    }

    final best = recentEntries[maxIndex].date;
    final worst = recentEntries[minIndex].date;

    String format(DateTime d) => '${d.day}/${d.month}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          moodText,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Divider(thickness: 1.2),
        Text("📈 Mejor día: ${format(best)}"),
        Text("📉 Peor día: ${format(worst)}"),
      ],
    );
  }

  // Compara el periodo actual con el anterior
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
      if (currentAvg >= 4.0) {
        return "Tu estado de ánimo se ha mantenido alto 😃";
      } else if (currentAvg <= 2.0) {
        return "Tu estado de ánimo sigue siendo bajo, cuídate 💙";
      } else {
        return "No hubo muchos cambios respecto al periodo anterior 🙃";
      }
    } else if (currentAvg > previousAvg) {
      return "Has mejorado respecto al periodo anterior 💪";
    } else {
      return "Tu estado de ánimo ha bajado respecto al periodo anterior 😕";
    }
  }


  @override
  Widget build(BuildContext context) {
    // Convertimos cada moodId a su puntuación numérica
    final moodValues = recentEntries.map((e) => moodScores[e.moodId]).toList();

    // Si no hay datos, mostramos mensaje vacío
    if (recentEntries.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Resumen')),
        body: Center(child: Text('Sin datos por ahora 😌')),
      );
    }

    // Identificamos el índice del mejor y peor día
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
              // Selector de rango (7, 15 o 30 días)
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

              // Interpretación del periodo actual
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    interpretWeek(),
                    SizedBox(height: 8),
                    // Comparativa con el periodo anterior
                    FutureBuilder(
                      future: compareWithPreviousPeriod(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox.shrink();
                        } else if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Gráfico de línea con estados de ánimo
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
                            // Colores diferentes para el mejor y peor día
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
