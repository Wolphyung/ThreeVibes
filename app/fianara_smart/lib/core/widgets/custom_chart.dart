import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class CustomChart extends StatelessWidget {
  final List<double> data;
  final AnimationController? animationController;

  const CustomChart({
    super.key,
    required this.data,
    this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('Aucune donnée disponible'),
      );
    }

    // Prendre seulement les 6 derniers points
    final displayData = data.length > 6 ? data.sublist(data.length - 6) : data;
    final maxValue = displayData.reduce((a, b) => a > b ? a : b);
    const chartHeight = 100.0;

    return SizedBox(
      height: 150,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth =
              (constraints.maxWidth / displayData.length).clamp(50.0, 80.0);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(displayData.length, (index) {
              final value = displayData[index];
              final barHeight = maxValue > 0
                  ? ((value / maxValue) * chartHeight).toDouble()
                  : 0.0;

              return SizedBox(
                width: itemWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: barHeight,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getShortMonthLabel(index),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }

  String _getShortMonthLabel(int index) {
    const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    if (index < months.length) {
      return months[index];
    }
    return '${index + 1}';
  }
}
