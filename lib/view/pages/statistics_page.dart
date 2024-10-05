import 'dart:developer' as dev;
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:liftday/constants/themes.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int _selectedRangeForBarChart = 7;
  final List<bool> _selectionsForBarChart = [true, false, false, false];
  int _selectedRangeForRadarChart = 7;
  final List<bool> _selectionsForRadarChart = [true, false, false, false];

  Future<Map<String, int>> _loadMuscleChartData(int range) async {
    ExerciseService exerciseService = ExerciseService();
    return await exerciseService.getMuscleChartData(appMuscleGroups, range);
  }

  Future<Map<List<String>, List<int>>> _loadVolumeChartData(int range) async {
    ExerciseService exerciseService = ExerciseService();
    final data = await exerciseService.getVolumeChartData(range);
    final bottomTitles =
        await exerciseService.getVolumeChartBottomTitles(range);
    return Map.of({bottomTitles: data});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Objętość treningowa",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    SizedBox(
                      height: 300,
                      child: FutureBuilder<Map<List<String>, List<int>>>(
                        future: _loadVolumeChartData(_selectedRangeForBarChart),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.done:
                              if (snapshot.hasData && snapshot.data != null) {
                                final y = _selectedRangeForBarChart;
                                return AppBarChart(
                                  numberOfXAxisValues: y,
                                  bottomTitles: const ["w1", "w2", "w3", "w4"],
                                );
                              } else {
                                return const SizedBox(height: 0);
                              }
                            default:
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ToggleButtons(
                  isSelected: _selectionsForBarChart,
                  borderRadius: BorderRadius.circular(8),
                  fillColor: Theme.of(context).colorScheme.onPrimary,
                  children: const [
                    //UWAGA NA RESPONSYWNOSC
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text("7 dni"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text("30 dni"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text("90 dni"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text("Cały okres"),
                    ),
                  ],
                  onPressed: (int newIndex) {
                    setState(() {
                      for (int i = 0; i < _selectionsForBarChart.length; i++) {
                        _selectionsForBarChart[i] = i == newIndex;
                      }
                      switch (newIndex) {
                        case 0:
                          _selectedRangeForBarChart = 7;
                          break;
                        case 1:
                          _selectedRangeForBarChart = 30;
                          break;
                        case 2:
                          _selectedRangeForBarChart = 90;
                          break;
                        case 3:
                          _selectedRangeForBarChart = -1;
                          break;
                      }
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Dystrybucja mięśni",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    SizedBox(
                      height: 300,
                      child: FutureBuilder<Map<String, int>>(
                        future:
                            _loadMuscleChartData(_selectedRangeForRadarChart),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.done:
                              if (snapshot.hasData && snapshot.data != null) {
                                return AppRadarChart(
                                    muscleChartData: snapshot.data!);
                              } else {
                                return const SizedBox(height: 0);
                              }
                            default:
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ToggleButtons(
                  isSelected: _selectionsForRadarChart,
                  borderRadius: BorderRadius.circular(8),
                  fillColor: Theme.of(context).colorScheme.onPrimary,
                  children: const [
                    //UWAGA NA RESPONSYWNOSC
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text("7 dni"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text("30 dni"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text("90 dni"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text("Cały okres"),
                    ),
                  ],
                  onPressed: (int newIndex) {
                    setState(() {
                      for (int i = 0;
                          i < _selectionsForRadarChart.length;
                          i++) {
                        _selectionsForRadarChart[i] = i == newIndex;
                      }
                      switch (newIndex) {
                        case 0:
                          _selectedRangeForRadarChart = 7;
                          break;
                        case 1:
                          _selectedRangeForRadarChart = 30;
                          break;
                        case 2:
                          _selectedRangeForRadarChart = 90;
                          break;
                        case 3:
                          _selectedRangeForRadarChart = -1;
                          break;
                      }
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppRadarChart extends StatefulWidget {
  final Map<String, int> muscleChartData;

  const AppRadarChart({
    super.key,
    required this.muscleChartData,
  });

  final titleColor = Colors.grey;

  @override
  State<AppRadarChart> createState() => _AppRadarChartState();
}

class _AppRadarChartState extends State<AppRadarChart> {
  @override
  Widget build(BuildContext context) {
    dev.log(widget.muscleChartData.toString());
    final muscleGroupNames = widget.muscleChartData.keys.toList();
    final setsPerMuscleGroup = widget.muscleChartData.values.toList();
    int maxNumber = setsPerMuscleGroup.reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: RadarChart(
              RadarChartData(
                dataSets: [
                  RadarDataSet(
                    dataEntries: setsPerMuscleGroup.map((value) {
                      return RadarEntry(value: value.toDouble());
                    }).toList(),
                  ),
                ],
                radarBackgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                radarBorderData: const BorderSide(color: Colors.transparent),
                titlePositionPercentageOffset: 0.2,
                titleTextStyle:
                    TextStyle(color: widget.titleColor, fontSize: 14),
                getTitle: (index, angle) {
                  if (index < muscleGroupNames.length) {
                    return RadarChartTitle(
                      text: muscleGroupNames[index],
                    );
                  }
                  return const RadarChartTitle(text: '');
                },
                tickCount: maxNumber,
                ticksTextStyle:
                    const TextStyle(fontSize: 0, color: Colors.transparent),
                tickBorderData: const BorderSide(color: Colors.transparent),
                gridBorderData: BorderSide(color: widget.titleColor, width: 2),
              ),
              swapAnimationDuration: const Duration(milliseconds: 400),
            ),
          ),
        ],
      ),
    );
  }
}

class AppBarChart extends StatefulWidget {
  final List<String> bottomTitles;
  final int numberOfXAxisValues;
  const AppBarChart(
      {super.key,
      required this.numberOfXAxisValues,
      required this.bottomTitles});

  final Color barColor = colorBabyBlue;

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<AppBarChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: BarChart(
                randomData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: widget.barColor,
          borderRadius: BorderRadius.zero,
          width: 12,
          borderSide: BorderSide(color: widget.barColor, width: 2.0),
        ),
      ],
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    const maxLeftValue = 29;

    if (value == maxLeftValue) {
      return const Text("");
    }

    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.grey,
    );

    return Text(value.toInt().toString(), style: style);
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.grey,
    );

    int index = value.toInt();

    if (index >= 0 && index < widget.bottomTitles.length) {
      return Text(widget.bottomTitles[index], style: style);
    } else {
      return const Text("");
    }
  }

  BarChartData randomData() {
    final int x = widget.numberOfXAxisValues;
    int verticalInterval;
    if (x == 7) {
      verticalInterval = 7;
    } else if (x == 30) {
      verticalInterval = 4;
    } else if (x == 90) {
      verticalInterval = 12;
    } else {
      verticalInterval = 12;
    }

    dev.log("x: $x");
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            getTitlesWidget: getBottomTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: getLeftTitles),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(
        verticalInterval,
        (i) => makeGroupData(
          i,
          Random().nextInt(29).toDouble() + 1,
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: verticalInterval.toDouble(),
        horizontalInterval: 5, // Set the interval between lines (optional)
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
        drawVerticalLine: false,
      ),
    );
  }
}

// class LineChartSample2 extends StatefulWidget {
//   const LineChartSample2({super.key});

//   @override
//   State<LineChartSample2> createState() => _LineChartSample2State();
// }

// class _LineChartSample2State extends State<LineChartSample2> {
//   List<Color> gradientColors1 = [
//     Colors.green,
//     Colors.green,
//   ];
//   List<Color> gradientColors2 = [
//     Colors.yellow,
//     Colors.yellow,
//   ];
//   List<Color> gradientColors3 = [
//     Colors.red,
//     Colors.red,
//   ];
//   List<Color> gradientColors4 = [
//     Colors.cyan,
//     Colors.cyan,
//   ];
//   List<Color> gradientColors5 = [
//     Colors.purple,
//     Colors.purple,
//   ];
//   List<Color> gradientColors6 = [
//     Colors.blue,
//     Colors.blue,
//   ];

//   bool showAvg = false;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AspectRatio(
//           aspectRatio: 1.0,
//           child: Padding(
//             padding: const EdgeInsets.only(
//               right: 0,
//               left: 0,
//               top: 0,
//               bottom: 0,
//             ),
//             child: LineChart(
//               showAvg ? avgData() : mainData(),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 5,
//           right: 0,
//           child: TextButton(
//             onPressed: () {
//               setState(() {
//                 showAvg = !showAvg;
//               });
//             },
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(
//                 showAvg
//                     ? Theme.of(context).colorScheme.tertiary.withOpacity(0.5)
//                     : Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
//               ),
//               foregroundColor: MaterialStateProperty.all(Colors.white),
//               shape: MaterialStateProperty.all(
//                 const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(4)),
//                 ),
//               ),
//             ),
//             child: showAvg
//                 ? const Text(
//                     'średnia',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 14,
//                     ),
//                   )
//                 : const Icon(Icons.show_chart),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 16,
//     );
//     Widget text;
//     switch (value.toInt()) {
//       case 0:
//         text = const Text('M', style: style);
//         break;
//       case 1:
//         text = const Text('T', style: style);
//         break;
//       case 2:
//         text = const Text('W', style: style);
//         break;
//       case 3:
//         text = const Text('T', style: style);
//         break;
//       case 4:
//         text = const Text('F', style: style);
//         break;
//       case 5:
//         text = const Text('S', style: style);
//         break;
//       case 6:
//         text = const Text('S', style: style);
//         break;
//       default:
//         text = const Text('', style: style);
//         break;
//     }

//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: text,
//     );
//   }

//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 15,
//     );
//     String text;
//     switch (value.toInt()) {
//       case 0:
//         text = '0k';
//         break;
//       case 5:
//         text = '5k';
//         break;
//       case 10:
//         text = '10k';
//         break;
//       default:
//         return Container();
//     }

//     return Text(text, style: style, textAlign: TextAlign.left);
//   }

//   LineChartData mainData() {
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: false,
//         horizontalInterval: 5,
//         verticalInterval: 1,
//         getDrawingHorizontalLine: (value) {
//           return const FlLine(
//             color: Color(0xff37434d),
//             strokeWidth: 1,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return const FlLine(
//             color: Color(0xff37434d),
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             interval: 1,
//             getTitlesWidget: bottomTitleWidgets,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             interval: 5,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 42,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: Border.all(color: const Color(0xff37434d)),
//       ),
//       minX: 0,
//       minY: 0,
//       lineBarsData: [
//         // Główna linia
//         LineChartBarData(
//           spots: const [
//             FlSpot(0, 4),
//             FlSpot(1, 3),
//             FlSpot(2, 2),
//             FlSpot(3, 10),
//             FlSpot(4, 3.1),
//             FlSpot(5, 4),
//             FlSpot(6, 3),
//           ],
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors1,
//           ),
//           barWidth: 3,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors1
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//           ),
//         ),

//         // Linia 1
//         LineChartBarData(
//           spots: const [
//             FlSpot(0, 2),
//             FlSpot(1, 5),
//             FlSpot(2, 3),
//             FlSpot(3, 7),
//             FlSpot(4, 4),
//             FlSpot(5, 6),
//             FlSpot(6, 5),
//           ],
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors2,
//           ),
//           barWidth: 3,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors2
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//           ),
//         ),

//         // Linia 2
//         LineChartBarData(
//           spots: const [
//             FlSpot(0, 6),
//             FlSpot(1, 2),
//             FlSpot(2, 5),
//             FlSpot(3, 3),
//             FlSpot(4, 7),
//             FlSpot(5, 4),
//             FlSpot(6, 6),
//           ],
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors3,
//           ),
//           barWidth: 3,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors3
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//           ),
//         ),

//         // Linia 3
//         LineChartBarData(
//           spots: const [
//             FlSpot(0, 1),
//             FlSpot(1, 4),
//             FlSpot(2, 7),
//             FlSpot(3, 5),
//             FlSpot(4, 3),
//             FlSpot(5, 8),
//             FlSpot(6, 7),
//           ],
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors2,
//           ),
//           barWidth: 3,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors2
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//           ),
//         ),

//         // Linia 4
//         LineChartBarData(
//           spots: const [
//             FlSpot(0, 5),
//             FlSpot(1, 6),
//             FlSpot(2, 8),
//             FlSpot(3, 4),
//             FlSpot(4, 2),
//             FlSpot(5, 9),
//             FlSpot(6, 5),
//           ],
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors5,
//           ),
//           barWidth: 3,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors5
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//           ),
//         ),

//         // Linia 5
//         LineChartBarData(
//           spots: const [
//             FlSpot(0, 3),
//             FlSpot(1, 7),
//             FlSpot(2, 6),
//             FlSpot(3, 9),
//             FlSpot(4, 5),
//             FlSpot(5, 2),
//             FlSpot(6, 4),
//           ],
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors4,
//           ),
//           barWidth: 3,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors4
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   LineChartData avgData() {
//     return LineChartData(
//       lineTouchData: const LineTouchData(enabled: true),
//       gridData: FlGridData(
//         show: true,
//         drawHorizontalLine: true,
//         verticalInterval: 1,
//         horizontalInterval: 1,
//         getDrawingVerticalLine: (value) {
//           return const FlLine(
//             color: Color(0xff37434d),
//             strokeWidth: 1,
//           );
//         },
//         getDrawingHorizontalLine: (value) {
//           return const FlLine(
//             color: Color(0xff37434d),
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             getTitlesWidget: bottomTitleWidgets,
//             interval: 1,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 42,
//             interval: 1,
//           ),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: Border.all(color: const Color(0xff37434d)),
//       ),
//       minX: 0,
//       minY: 0,
//       maxY: 6,
//       lineBarsData: [
//         LineChartBarData(
//           spots: const [
//             FlSpot(0, 3.44),
//             FlSpot(2.6, 3.44),
//             FlSpot(4.9, 3.44),
//             FlSpot(6.8, 3.44),
//             FlSpot(8, 3.44),
//             FlSpot(9.5, 3.44),
//             FlSpot(11, 3.44),
//           ],
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: [
//               ColorTween(begin: gradientColors1[0], end: gradientColors1[1])
//                   .lerp(0.2)!,
//               ColorTween(begin: gradientColors1[0], end: gradientColors1[1])
//                   .lerp(0.2)!,
//             ],
//           ),
//           barWidth: 5,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: [
//                 ColorTween(begin: gradientColors1[0], end: gradientColors1[1])
//                     .lerp(0.2)!
//                     .withOpacity(0.1),
//                 ColorTween(begin: gradientColors1[0], end: gradientColors1[1])
//                     .lerp(0.2)!
//                     .withOpacity(0.1),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
