import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class LineGraph extends StatefulWidget {
  const LineGraph({super.key});

  @override
  State<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  Map<String, int> completedSchedules = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      AdminRepositoryImpl scheduleService = AdminRepositoryImpl();
      Map<String, int> data = await scheduleService.fetchCompletedSchedulesByDay();
      setState(() {
        completedSchedules = data;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching schedule data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 275,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 5,
                  minY: 0,
                  maxY: 10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getSpotsFromData(),
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
                          return _getDayLabel(value.toInt());
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

  // Helper to convert the data into FlSpot list
  List<FlSpot> _getSpotsFromData() {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    List<FlSpot> spots = [];

    for (int i = 0; i < days.length; i++) {
      final count = completedSchedules[days[i]] ?? 0;
      spots.add(FlSpot(i.toDouble(), count.toDouble()));
    }

    return spots;
  }

  // Helper to get the labels for the X-axis
  Widget _getDayLabel(int index) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    if (index < 0 || index >= days.length) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Text(
        days[index],
        style: const TextStyle(
          color: ColorPalette.accentBlack,
          fontSize: 8,
        ),
      ),
    );
  }
}
