import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonthlyIncomeExpenseChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  MonthlyIncomeExpenseChart({required this.data});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(30),
      child: SizedBox(
        width: 240,
        height: 240,
        child: SfCartesianChart(primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(minimum: 0),
        series: <CartesianSeries<Map<String, dynamic>,String>>[
          ColumnSeries(
            dataSource: data,
            xValueMapper: (Map<String, dynamic> data, _) => data["month"],
            yValueMapper: (Map<String, dynamic> data, _) => data["income"],
            color: Color(0xffb457ba),
          ),
          
          ColumnSeries(
              dataSource: data,
              xValueMapper: (Map<String, dynamic> data, _) => data["month"],
              yValueMapper: (Map<String, dynamic> data, _) => data["expense"],
            color: Color(0xff49194d),
          ),
        ],),
      ),
    );
  }
}
