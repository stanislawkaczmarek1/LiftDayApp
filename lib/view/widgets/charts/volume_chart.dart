import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:liftday/constants/themes.dart';
import 'package:liftday/sevices/conversion/conversion_service.dart';
import 'package:liftday/sevices/crud/data_package/volume_chart_data.dart';

class VolumeChart extends StatefulWidget {
  final List<VolumeChartData> data;
  final int range;
  const VolumeChart({
    super.key,
    required this.data,
    required this.range,
  });

  final Color barColor = colorBabyBlue;

  @override
  State<StatefulWidget> createState() => _VolumeChartState();
}

class _VolumeChartState extends State<VolumeChart> {
  late List<int> _yAxisValues;
  late List<String> _bottomTitles;
  final int _numberOfDaysInWeek = 7;
  final int _numberOfDaysInMonth = 30;
  final int _numberOfDaysInThreeMonts = 90;

  @override
  void initState() {
    _yAxisValues = widget.data.map((data) => data.volume).toList();
    _bottomTitles = widget.data.map((data) => data.bottomTitle).toList();

    if (widget.data.length != _numberOfDaysInWeek) {
      final listAfterRemovingDuplicates =
          ConversionService.removeDuplicates(_bottomTitles);
      final listAfterTransformation =
          ConversionService.transformList(listAfterRemovingDuplicates);

      _bottomTitles = listAfterTransformation;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: 300,
          width: 400,
          child: BarChart(
            chartData(),
          ),
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

  Widget getRightTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.grey,
    );

    final convertedText = ConversionService.formatNumberInYAxis(value);
    return Text(convertedText, style: style);
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.grey,
    );

    int index = value.toInt();

    if (index >= 0 && index < _bottomTitles.length) {
      if (widget.data.length == _numberOfDaysInWeek) {
        final covertedText =
            ConversionService.getDayOfWeekOneLetter(_bottomTitles[index]);

        return Text(covertedText, style: style);
      } else {
        final convertedText =
            ConversionService.getDayOfMonthThreeLetters(_bottomTitles[index]);

        return Text(convertedText, style: style);
      }
    } else {
      return const Text("");
    }
  }

  BarChartData chartData() {
    final int numberOfXAxisValues = widget.range;
    final yAxisValuesData = _yAxisValues;
    int maxXAxisValue;
    int horizontalInterval;
    if (yAxisValuesData.isNotEmpty) {
      maxXAxisValue = yAxisValuesData.reduce((a, b) => a > b ? a : b);
      horizontalInterval = (maxXAxisValue / 4).ceil();
    } else {
      maxXAxisValue = 1;
      horizontalInterval = 1;
    }
    if (maxXAxisValue == 0) {
      maxXAxisValue = 1;
      horizontalInterval = 1;
    }

    int verticalInterval;
    if (numberOfXAxisValues == _numberOfDaysInWeek) {
      verticalInterval = 7;
    } else if (numberOfXAxisValues == _numberOfDaysInMonth) {
      verticalInterval = 4;
    } else if (numberOfXAxisValues == _numberOfDaysInThreeMonts) {
      verticalInterval = 12;
    } else {
      verticalInterval = 12;
    }

    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getBottomTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getRightTitles,
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
          yAxisValuesData.elementAt(i).toDouble(),
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: verticalInterval.toDouble(),
        horizontalInterval: horizontalInterval.toDouble(),
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
