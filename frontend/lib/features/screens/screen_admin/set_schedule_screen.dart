import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';

class SetScheduleScreen extends StatefulWidget {
  @override
  _SetScheduleScreenState createState() => _SetScheduleScreenState();
}

class _SetScheduleScreenState extends State<SetScheduleScreen> {
  DateTime? selectedDate;
  String? selectedTimeSlot;
  String? selectedProfessor;

  final List<String> timeSlots = [
    '7 AM',
    '8 AM',
    '9 AM',
    '10 AM',
    '11 AM',
    '12 PM',
    '1 PM',
    '2 PM',
    '3 PM',
    '4 PM',
    '5 PM',
  ];

  final List<Map<String, String>> professors = [
    {'name': 'John Doe', 'image': 'assets/john_doe.png'},
    {'name': 'Jane Smith', 'image': 'assets/jane_smith.png'},
    // Add more professors here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Schedule Duty", isBackButton: true),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date',
              style: TextStyle(
                color: Color(0xFF6D7278),
                fontSize: 15,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                color: Colors.grey[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}'
                          : 'Select',
                      style: TextStyle(
                        color: ColorPalette.accentBlack,
                        fontFamily: 'Manrope',
                        fontSize: 11,
                      ),
                    ),
                    Icon(Icons.calendar_today, color: Color(0xFF6D7278)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Time',
              style: TextStyle(
                color: Color(0xFF6D7278),
                fontSize: 15,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: timeSlots.map((slot) {
                return ChoiceChip(
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  shape: RoundedRectangleBorder(side: BorderSide.none),
                  label: Text(
                    slot,
                    style: TextStyle(
                      color: ColorPalette.accentBlack,
                      fontFamily: 'Manrope',
                      fontSize: 11,
                    ),
                  ),
                  selected: selectedTimeSlot == slot,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedTimeSlot = selected ? slot : null;
                    });
                  },
                  backgroundColor: Colors.grey[50],
                  selectedColor: ColorPalette.accent,
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Text(
              'Select Professor',
              style: TextStyle(
                color: Color(0xFF6D7278),
                fontSize: 15,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedProfessor,
              hint: Text(
                "Select Professor",
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 12,
                ),
              ),
              items: professors.map((professor) {
                return DropdownMenuItem<String>(
                  value: professor['name'],
                  child: Text(professor['name']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProfessor = value;
                });
              },
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                width: MediaQuery.of(context).size.width * .9,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorPalette.btnColor,
                ),
                child: TextButton(
                  onPressed: selectedDate != null &&
                          selectedTimeSlot != null &&
                          selectedProfessor != null
                      ? () {
                          // Confirm the scheduling here
                        }
                      : null,
                  child: Text(
                    'Confirm',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
