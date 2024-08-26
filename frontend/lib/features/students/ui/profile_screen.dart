import 'package:flutter/material.dart';
import 'package:isHKolarium/constants/colors.dart';
import 'package:isHKolarium/features/students/widgets/profile_widgets/profile_account_option.dart';
import 'package:isHKolarium/features/students/widgets/profile_widgets/profile_account_section.dart';
import 'package:isHKolarium/features/students/widgets/profile_widgets/profile_divider.dart';
import 'package:isHKolarium/features/students/widgets/profile_widgets/profile_info_data.dart';
import 'package:isHKolarium/features/students/widgets/profile_widgets/profile_info_section.dart';
import '../widgets/profile_widgets/profile_circle.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Container(
              height: 100.0,
              color: ColorPalette.primary,
              alignment: Alignment.centerLeft,
              child: const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    SizedBox(height: 50),
                    const ProfileCircle(),
                    SizedBox(height: 80),
                    InfoSection(
                      title: 'BASIC INFORMATION',
                      infoRows: [
                        const SizedBox(height: 20),
                        const InfoRow(
                            label: 'Name', value: 'David Aldrin Mondero'),
                        const SizedBox(height: 15),
                        const DividerWidget(),
                        const SizedBox(height: 15),
                        const InfoRow(
                            label: 'Email',
                            value: 'dafe.mondero.up@phinmaed.com'),
                        const SizedBox(height: 15),
                        const DividerWidget(),
                        const SizedBox(height: 15),
                        const InfoRow(
                            label: 'Student ID', value: '03-2223-12345'),
                        const SizedBox(height: 15),
                        const DividerWidget(),
                        const SizedBox(height: 15),
                        const InfoRow(label: 'HK Type', value: '50%'),
                        const SizedBox(height: 15),
                        const DividerWidget(),
                        const SizedBox(height: 15),
                        const InfoRow(label: 'Status', value: 'Active'),
                      ],
                    ),
                    SizedBox(height: 30),
                    const AccountSection(),
                    SizedBox(height: 20),
                    const AccountOptions(),
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
