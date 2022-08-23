import 'package:expense_manager/model/transaction_model.dart';

import '../../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

/// This component handles drawing of line graph, a list of transactions
/// is passed to it, this list is seperated into expenses and income categories
/// which is then plotted as lines in a graph
// ignore: must_be_immutable
class ChartComponent extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  List<Data> transaction;
  ChartComponent({Key? key, required this.transaction}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChartComponent> {
  List<_SalesData> income = [];
  List<_SalesData> expense = [];
  @override
  void initState() {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    super.initState();
    final date = DateTime.now();
    int currentMonth = date.month;
    List<Data> incomeList = [];
    List<Data> expenseList = [];
    for (int i = 0; i < widget.transaction.length; i++) {
      if (widget.transaction[i].type == "INCOME") {
        incomeList.add(widget.transaction[i]);
      } else {
        expenseList.add(widget.transaction[i]);
      }
    }

    for (int j = 1; j <= currentMonth; j++) {
      income.add(_SalesData(months[j], _getTotal(j, incomeList)));
      expense.add(_SalesData(months[j], _getTotal(j, expenseList)));
    }
  }

  double _getTotal(int month, List<Data> transaction) {
    double total = 0;
    for (int i = 0; i < transaction.length; i++) {
      final dateTime = DateTime.parse(transaction[i].date);
      if (dateTime.month == month) {
        total += double.parse(transaction[i].amount);
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //Initialize the chart widget
      SfCartesianChart(
          primaryXAxis: CategoryAxis(),

          // Enable legend
          legend: Legend(isVisible: false),
          // Enable tooltip
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<_SalesData, String>>[
            LineSeries<_SalesData, String>(
                dataSource: income,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'Sales',
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true)),
            LineSeries<_SalesData, String>(
                dataSource: expense,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'Sales',
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true))
          ]),
    ]);
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
