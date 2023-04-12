import 'dart:io';

import 'package:flutter/material.dart';

import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/transaction_sheet.dart';
import './widgets/transactions_chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      home: const MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Inter',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final List<Transaction> _transactions = [];

  List<Transaction> get _recentTransactions {
    return _transactions.where((item) {
      return item.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  bool _showChart = false;

  void _addTransaction(String title, double amount, DateTime date) {
    final transaction = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: date,
    );

    setState(() {
      _transactions.add(transaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((item) => item.id == id);
    });
  }

  void showNewTransactionForm(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (builderCtx) {
        return TransactionSheet(
          addTransactionCallback: _addTransaction,
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    );
  }

  double getDynamicHeight(percentage, appBar) {
    final mediaQuery = MediaQuery.of(context);
    return (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top) *
        percentage;
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: const Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          onPressed: () => showNewTransactionForm(context),
          icon: const Icon(Icons.add_rounded),
        ),
      ],
    );
    final chartWidget = SizedBox(
      height: getDynamicHeight(isLandscape ? 0.8 : 0.3, appBar),
      child: TransactionsChart(
        recentTransactions: _recentTransactions,
      ),
    );
    final transactionListWidget = SizedBox(
      height: getDynamicHeight(0.75, appBar),
      child: TransactionList(
        transactions: _transactions,
        deleteTransactionCallback: _deleteTransaction,
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Text('Show chart'),
                  const SizedBox(
                    width: 10,
                  ),
                  Switch.adaptive(
                    value: _showChart,
                    onChanged: (flag) {
                      setState(() {
                        _showChart = flag;
                      });
                    },
                  ),
                ],
              ),
            if (isLandscape) _showChart ? chartWidget : transactionListWidget,
            if (!isLandscape) chartWidget,
            if (!isLandscape) transactionListWidget,
          ],
        ),
      ),
      floatingActionButton: Platform.isAndroid
          ? FloatingActionButton(
              onPressed: () => showNewTransactionForm(context),
              child: const Icon(Icons.add_rounded),
            )
          : Container(),
    );
  }
}
