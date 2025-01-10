import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BudgetLineChart extends StatelessWidget{
  final List<Map<String, dynamic>> data;
  final bool income;

  BudgetLineChart({required this.data, this.income=false,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: SizedBox(
        width: 240,
        height: 240,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <CartesianSeries<Map<String, dynamic>,String>>[
            LineSeries(
              xValueMapper: (Map<String, dynamic> data, _) => data["day"],
              yValueMapper: (Map<String, dynamic> data, _) => (income==true ? data["income"] : data["expense"]),
              dataSource: data,
              color: Color(0xFF97349e),
              markerSettings: MarkerSettings(shape: DataMarkerType.circle, isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}