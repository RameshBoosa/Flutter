import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_budget/models/transaction.dart';
import 'package:personal_budget/widgets/chart_bar.dart';

class MyChart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  MyChart(this.recentTransactions);

  List<Map<String, Object>> get finalGroupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return finalGroupedTransactions.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('groupedTransactions: ${finalGroupedTransactions}');
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: finalGroupedTransactions.map((item) {
            return Flexible(
              fit: FlexFit.tight,
              child: Chart(
                item['day'],
                item['amount'],
                totalSpending == 0.0
                    ? 0.0
                    : (item['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
