import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryPieChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool income;

  CategoryPieChart({required this.data, this.income = false});

  @override
  Widget build(BuildContext context) {

    final double total = data.fold(
      0,
          (sum, item) => sum + (income ? item["income"] : item["expense"]),
    );

    return Padding(
      padding: const EdgeInsets.all(30),
      child: SizedBox(
        width: 250,
        height: 250,
        child: SfCircularChart(
          legend: Legend(isVisible: true, position: LegendPosition.right,overflowMode: LegendItemOverflowMode.scroll,),
          series: <CircularSeries>[
            PieSeries<Map<String, dynamic>, String>(
              dataSource: data,
              xValueMapper: (Map<String, dynamic> data, _) => data["category"],
              yValueMapper: (Map<String, dynamic> data, _) => (income ? data["income"] : data["expense"]),
              pointColorMapper: (Map<String, dynamic> data, _) => data["color"],
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                // Handle overlapping labels
                labelIntersectAction: LabelIntersectAction.shift,
              ),
              dataLabelMapper: (Map<String, dynamic> data, _) {
                final int value =
                income ? data["income"] : data["expense"];
                final double percentage = (value / total) * 100;
                return '${percentage.toStringAsFixed(1)}%';
              },
            ),
          ],
        ),
      ),
    );
  }
}
