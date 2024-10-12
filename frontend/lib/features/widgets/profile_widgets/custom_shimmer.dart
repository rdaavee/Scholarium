import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomSkeletonLoader extends StatelessWidget {
  final int itemCount;
  final double circleSize;
  final double longRectangleHeight;
  final double shortRectangleHeight;
  final Color baseColor;
  final Color highlightColor;

  const CustomSkeletonLoader({
    super.key,
    this.itemCount = 6,
    this.circleSize = 100.0,
    this.longRectangleHeight = 30.0,
    this.shortRectangleHeight = 20.0,
    this.baseColor = const Color(0xFFe0e0e0),
    this.highlightColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView(
        children: [
          const SizedBox(height: 50),
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: baseColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 80),
          _buildRectangle(context, longRectangleHeight),
          const SizedBox(height: 20),
          _buildRectangle(context, shortRectangleHeight),
          const SizedBox(height: 15),
          ...List.generate(itemCount, (index) {
            return Column(
              children: [
                Divider(color: baseColor),
                const SizedBox(height: 15),
                _buildRectangle(context, shortRectangleHeight),
              ],
            );
          }),
          const SizedBox(height: 30),
          _buildRectangle(context, 40),
          const SizedBox(height: 20),
          _buildRectangle(context, 40),
        ],
      ),
    );
  }

  Widget _buildRectangle(BuildContext context, double height) {
    return Container(
      width: double.infinity,
      height: height,
      color: baseColor,
    );
  }
}
