import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TaskPieChart extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;

  const TaskPieChart({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    int pendingTasks = totalTasks - completedTasks;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: [
            PieChartSectionData(
              value: completedTasks.toDouble(),
              color: Color.fromRGBO(75, 71, 184, 1),
              title:
                  '${((completedTasks / totalTasks) * 100).toStringAsFixed(1)}%',
              titleStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              radius: 50,
            ),
            PieChartSectionData(
              value: pendingTasks.toDouble(),
              color: Color.fromRGBO(189, 187, 232, 1),
              title:
                  '${((pendingTasks / totalTasks) * 100).toStringAsFixed(1)}%',
              titleStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              radius: 50,
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildLegendItem({required Color color, required String label}) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(label, style: TextStyle(color: Colors.white)),
    ],
  );
}
