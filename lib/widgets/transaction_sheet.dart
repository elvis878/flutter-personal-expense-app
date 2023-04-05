import 'package:flutter/material.dart';

import 'transaction_form.dart';

class TransactionSheet extends StatelessWidget {
  final Function addTransactionCallback;

  const TransactionSheet({
    super.key,
    required this.addTransactionCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              // this will push the bottom sheet up when
              // the software keyboard is showing
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(
                    'New transaction',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TransactionForm(addTransactionCallback: addTransactionCallback),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
