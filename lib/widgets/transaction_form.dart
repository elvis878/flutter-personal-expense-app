import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final Function addTransactionCallback;

  const TransactionForm({
    super.key,
    required this.addTransactionCallback,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _submitFn() {
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);

    if (title.isEmpty || amount <= 0) {
      return;
    }

    widget.addTransactionCallback(
      title,
      amount,
      _selectedDate,
    );

    // close bottom modal sheet
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(
          days: 365,
        ),
      ),
      lastDate: DateTime.now(),
    ).then((chosenDate) {
      if (chosenDate == null) {
        return;
      }

      setState(() {
        _selectedDate = chosenDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
            controller: _titleController,
            onSubmitted: (_) => _submitFn(),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Amount',
            ),
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            onSubmitted: (_) => _submitFn(),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              TextButton.icon(
                onPressed: _presentDatePicker,
                icon: const Icon(Icons.calendar_month_rounded),
                label: const Text('Choose date'),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(_selectedDate == null
                  ? 'No date chosen yet.'
                  : DateFormat('EEE, d MMM yyyy').format(_selectedDate)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.cancel_rounded),
                label: const Text('Cancel'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                onPressed: _submitFn,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Save transaction'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
