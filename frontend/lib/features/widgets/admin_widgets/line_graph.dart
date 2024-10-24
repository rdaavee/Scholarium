import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class LineGraph extends StatefulWidget {
  const LineGraph({super.key});

  @override
  State<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 275,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 5,
            minY: 0,
            maxY: 10,
            lineBarsData: [
              LineChartBarData(
                spots: [
                  const FlSpot(0, 4),
                  const FlSpot(1, 6),
                  const FlSpot(2, 8),
                  const FlSpot(3, 6.2),
                  const FlSpot(4, 6),
                  const FlSpot(5, 8),
                ],
                isCurved: true,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF113462),
                    Color(0xFF0C7FD0),
                  ],
                ),
                barWidth: 2,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(17, 52, 98, 0.5),
                      Color.fromRGBO(12, 127, 208, 0.5),
                    ],
                  ),
                ),
                dotData: FlDotData(show: false),
              ),
            ],
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: false,
              drawVerticalLine: true,
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: ColorPalette.primary,
                  strokeWidth: 0.25,
                );
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value % 1 != 0 || value < 0 || value > 5) {
                      return Container();
                    }
                    String text = "";
                    switch (value.toInt()) {
                      case 0:
                        text = "Mon";
                        break;
                      case 1:
                        text = "Tue";
                        break;
                      case 2:
                        text = "Wed";
                        break;
                      case 3:
                        text = "Thu";
                        break;
                      case 4:
                        text = "Fri";
                        break;
                      case 5:
                        text = "Sat";
                        break;
                      default:
                        return Container();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        text,
                        style: const TextStyle(
                          color: ColorPalette.accentBlack,
                          fontSize: 8,
                        ),
                      ),
                    );
                  },
                  reservedSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
