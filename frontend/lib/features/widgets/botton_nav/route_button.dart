// import 'package:flutter/material.dart';
// import 'package:isHKolarium/config/constants/colors.dart'; // Make sure to adjust the import based on your project structure

// class RouteButton extends StatelessWidget {
//   final String routeName;
//   final String filePath;
//   final VoidCallback routeCallback;
//   final int currentIndex;
//   final int routeIndex;

//   const RouteButton({
//     Key? key,
//     required this.routeName,
//     required this.filePath,
//     required this.routeCallback,
//     required this.currentIndex,
//     required this.routeIndex,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: routeCallback,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image.asset(
//             filePath,
//             height: 25,
//             width: 25,
//             color: currentIndex == routeIndex
//                 ? ColorPalette.primary // Use your primary color
//                 : const Color(0xff585858), // Use a default color for unselected
//           ),
//           const SizedBox(height: 2.5),
//           Text(
//             routeName,
//             style: TextStyle(
//               color: currentIndex == routeIndex
//                   ? ColorPalette.primary // Use your primary color
//                   : const Color(
//                       0xff585858), // Use a default color for unselected
//               fontWeight: FontWeight.w300,
//               fontFamily: "Montserrat", // Adjust the font family as needed
//               fontSize: 10,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
