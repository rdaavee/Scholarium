import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/duty_card.dart';

class ProfessorHomeScreen extends StatelessWidget {
  const ProfessorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Container(
              height: 100.0,
              color: ColorPalette.primary,
              alignment: Alignment.centerLeft,
              child: const Text(
                "Hi, Professor",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height - 100.0,
              decoration: const BoxDecoration(
                color: Color(0xFFF0F3F4),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Center(
                                    child: SizedBox(
                                      width: 100,
                                      child: Divider(
                                        height: 20,
                                        thickness: 0.8,
                                        color: Color(0xFFC1C1C1),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Post Something',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Manrope',
                                      fontSize: 18,
                                      color: Color(0xFF6D7278),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      hintText: 'Write something...',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6D7278),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF549E73),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6D7278),
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                        horizontal: 20,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                      ).copyWith(
                                        elevation:
                                            ButtonStyleButton.allOrNull(0.0),
                                        backgroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.hovered)) {
                                              return const Color(0xFF549E73);
                                            }
                                            return const Color(0xFFC1C1C1);
                                          },
                                        ),
                                      ),
                                      child: const Text('Post'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.transparent),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 25,
                              child: const Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Post something',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Manrope',
                                  fontSize: 15,
                                  color: Color(0xFFC1C1C1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 0.2,
                      color: Color(0xFF6D7278),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Ongoing Duties',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6D7278),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: const [
                          DutyCard(
                            cardColor: Color(0xFF549E73),
                            time: '7:30AM-9:00AM',
                            roomName: 'PTC-206',
                          ),
                          SizedBox(height: 16),
                          DutyCard(
                            cardColor: Color(0xFF6DD400),
                            time: '7:30AM-9:00AM',
                            roomName: 'PTC-206',
                          ),
                        ],
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
