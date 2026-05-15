import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';

class CustomChart extends StatelessWidget {
  final List<double> data;
  final AnimationController animationController;

  const CustomChart({
    super.key,
    required this.data,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.show_chart, size: 50, color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              'Graphique des signalements',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                data.length,
                (index) => Column(
                  children: [
                    Container(
                      height: data[index] * 2,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text('Mois ${index + 1}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
