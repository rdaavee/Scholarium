import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the fl_chart package
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/duty_card.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Container(
              height: 150.0,
              color: ColorPalette.primary,
              alignment: Alignment.centerLeft,
              child: const Text(
                "Good Morning,\nAdmin",
                style: TextStyle(
                  fontSize: 23,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: ColorPalette.accentWhite,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F3F4),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '60',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  color: Color(0xFFC1C1C1),
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '60',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Ongoing',
                                style: TextStyle(
                                  color: Color(0xFFC1C1C1),
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '60',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Backlogs',
                                style: TextStyle(
                                  color: Color(0xFFC1C1C1),
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 280,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: Colors.green,
                                value: 190,
                                title: 'Active',
                                radius: 120,
                                titleStyle: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              PieChartSectionData(
                                color: Colors.grey[350],
                                value: 30,
                                title: 'Inactive',
                                radius: 120,
                                titleStyle: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0,
                            centerSpaceRadius: 0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Ongoing Duties',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6D7278),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 225,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            const DutyCard(
                              cardColor: Color(0xFF549E73),
                              time: '7:30AM-9:00AM',
                              roomName: 'PTC-206',
                            ),
                            const SizedBox(width: 16),
                            const DutyCard(
                              cardColor: Color(0xFF6DD400),
                              time: '7:30AM-9:00AM',
                              roomName: 'PTC-206',
                            ),
                            const SizedBox(width: 16),
                            const DutyCard(
                              cardColor: Color(0xFF549E73),
                              time: '7:30AM-9:00AM',
                              roomName: 'PTC-206',
                            ),
                            const SizedBox(width: 16),
                            const DutyCard(
                              cardColor: Color(0xFF6DD400),
                              time: '7:30AM-9:00AM',
                              roomName: 'PTC-206',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
