import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class AdminMonitoring extends StatefulWidget {
  final int announcementCount;
  final int dtrCompletedCount;
  const AdminMonitoring(
      {super.key,
      required this.announcementCount,
      required this.dtrCompletedCount});

  @override
  State<AdminMonitoring> createState() => _AdminMonitoringState();
}

class _AdminMonitoringState extends State<AdminMonitoring> {
  // final List itemList = [
  //   "Whole Week",
  //   "Monday",
  //   "Tuesday",
  //   "Wednesday",
  //   "Thursday",
  //   "Friday",
  //   "Saturday",
  // ];

  // String? selectedValue = "Whole Week";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            announcementContainer(
              context,
              CupertinoIcons.bell_circle_fill,
              "Announcements",
              widget.announcementCount,
              ColorPalette.primary,
              Colors.white,
            ),
            announcementContainer(
              context,
              CupertinoIcons.checkmark_alt_circle_fill,
              "DTR Completed",
              widget.dtrCompletedCount,
              ColorPalette.primary,
              Colors.white,
            ),
          ],
        ),
        // SizedBox(
        //   width: 180,
        //   child: Column(
        //     children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Text(
        //             "Day",
        //             style: TextStyle(
        //               color: const Color(0xFF6D7278),
        //               fontSize: 14,
        //             ),
        //           ),
        //           Text(
        //             "Week",
        //             style: TextStyle(
        //               color: const Color(0xFF6D7278),
        //               fontSize: 14,
        //             ),
        //           ),
        // Text(
        //   "Month",
        //   style: TextStyle(
        //     color: ColorPalette.primary,
        //     fontSize: 14,
        //   ),
        // ),
        //         ],
        //       ),
        //       Container(
        //         padding: EdgeInsets.symmetric(horizontal: 8),
        //         height: 30,
        //         width: 180,
        //         decoration: BoxDecoration(
        //           color: Color(0xFFEBEBEB),
        //           borderRadius: BorderRadius.circular(5),
        //         ),
        //         child: DropdownButtonHideUnderline(
        //           child: DropdownButton(
        //             value: selectedValue,
        //             dropdownColor: ColorPalette.accent,
        //             items: itemList.map<DropdownMenuItem<String>>((value) {
        //               return DropdownMenuItem<String>(
        //                 value: value,
        //                 child: Text(
        //                   value,
        //                   style: TextStyle(
        //                     color: ColorPalette.accentBlack,
        //                     fontSize: 13,
        //                   ),
        //                 ),
        //               );
        //             }).toList(),
        //             onChanged: (String? newValue) {
        //               setState(() {
        //                 selectedValue = newValue;
        //               });
        //             },
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget announcementContainer(BuildContext context, IconData icon, String text,
      int announcementCreated, Color color, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        height: 100,
        width: 180,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  icon,
                  color: textColor,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "$announcementCreated",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
