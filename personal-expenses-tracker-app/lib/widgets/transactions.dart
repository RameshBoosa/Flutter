import 'package:flutter/material.dart';
import 'package:personal_budget/models/transaction.dart';
import 'package:personal_budget/widgets/transactionItem.dart';

class Transactions extends StatelessWidget {
  final List<Transaction> allTransactions;
  final Function deleteActionHandler;

  Transactions(this.allTransactions, this.deleteActionHandler);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        child: ListView(
          children: allTransactions
              .map((transaction) => TransactionItem(
                  key: ValueKey(transaction.id),
                  transaction: transaction,
                  deleteActionHandler: deleteActionHandler))
              .toList(),
        ),
      ),
    );
  }
}
