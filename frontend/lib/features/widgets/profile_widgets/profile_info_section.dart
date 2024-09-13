import 'package:flutter/material.dart';
import 'package:isHKolarium/features/widgets/profile_widgets/profile_divider.dart';
import 'package:isHKolarium/features/widgets/profile_widgets/profile_info_header.dart';

class InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> infoRows;

  const InfoSection({
    required this.title,
    required this.infoRows,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoHeader(title: title),
        const SizedBox(height: 10),
        ...infoRows,
        const SizedBox(height: 20),
        const DividerWidget(),
      ],
    );
  }
}
