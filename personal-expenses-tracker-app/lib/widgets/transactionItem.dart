import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:personal_budget/models/transaction.dart';
import '../widgets/text.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem(
      {Key key, @required this.transaction, @required this.deleteActionHandler})
      : super(key: key);

  final Transaction transaction;
  final Function deleteActionHandler;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;

  @override
  void initState() {
    const colors = [
      Colors.black,
      Colors.red,
      Colors.orange,
      Colors.deepOrange,
      Colors.blue,
      Colors.blueGrey
    ];
    _bgColor = colors[Random().nextInt(colors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: FittedBox(
              child: MyText(
                  text: '\$${widget.transaction.amount.toStringAsFixed(2)}',
                  color: Colors.white),
            ),
          ),
        ),
        title: MyText(
          text: widget.transaction.title,
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        subtitle: MyText(
            text: DateFormat.yMEd().format(widget.transaction.date) +
                '\n' +
                widget.transaction.description,
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.normal),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: () => widget.deleteActionHandler(widget.transaction.id),
        ),
      ),
    );
  }
}
