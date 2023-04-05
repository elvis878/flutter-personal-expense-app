import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './bar_chart.dart';
import '../models/transaction.dart';

class TransactionsChart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final DateTime weekDay = DateTime.now().subtract(Duration(days: index));
      final String weekDayAbbr = DateFormat('E').format(weekDay);
      double totalPerDay = 0;

      for (var transaction in recentTransactions) {
        if (transaction.date.day == weekDay.day &&
            transaction.date.month == weekDay.month &&
            transaction.date.year == weekDay.year) {
          totalPerDay += transaction.amount;
        }
      }

      return {
        'day': weekDayAbbr.substring(0, weekDayAbbr == 'Thu' ? 2 : 1),
        'amount': totalPerDay,
      };
    }).reversed.toList();
  }

  double totalSpending(amount) {
    var total = groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });

    return total == 0.0 ? 0.0 : amount / total;
  }

  const TransactionsChart({
    super.key,
    required this.recentTransactions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: groupedTransactionValues.map((data) {
            return BarChart(
              label: data['day'].toString(),
              spendingAmount: double.parse(data['amount'].toString()),
              percentage: totalSpending(data['amount']),
            );
          }).toList(),
        ),
      ),
    );
  }
}
