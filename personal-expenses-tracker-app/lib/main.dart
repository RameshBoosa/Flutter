import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:personal_budget/widgets/charts.dart';
import 'package:personal_budget/widgets/dashboard_placeholder.dart';
import 'package:personal_budget/widgets/new_transaction.dart';
import 'package:personal_budget/widgets/text.dart';
import './widgets/transactions.dart';
import './models/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const _navbarTitle = 'Personal Budget';
  @override
  Widget build(BuildContext context) {
    return /*Platform.isIOS
        ? CupertinoApp(
            debugShowCheckedModeBanner: false,
            title: _navbarTitle,
            home: Dashboard(),
          )
        : */
        MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _navbarTitle,
      theme: ThemeData(
        fontFamily: 'OpenSans',
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String title, double amount, String description, DateTime selectedDate) {
    final transaction = Transaction(
        title: title,
        amount: amount,
        id: UniqueKey().toString(),
        description: description,
        date: selectedDate);

    setState(() {
      _userTransactions.add(transaction);
    });
  }

  void _deleteTransaction(String id) {
    if (_userTransactions.length > 0) {
      setState(() {
        _userTransactions.removeWhere((transaction) => transaction.id == id);
      });
    }
  }

  void _createAndDisplayAddTransactionWidget(BuildContext ctx) {
    Navigator.of(ctx).push(Platform.isIOS
        ? CupertinoPageRoute(builder: (_) {
            return NewTransaction(_addNewTransaction);
          })
        : MaterialPageRoute(builder: (_) {
            return NewTransaction(_addNewTransaction);
          }));
  }

  @override
  Widget build(BuildContext context) {
    var bgColor = Colors.black;
    var navBarColor = Color.fromRGBO(38, 50, 56, 1);
    var screenHeight = (MediaQuery.of(context).size.height);
    var screenWidth = (MediaQuery.of(context).size.width);
    var isLandScape =
        (MediaQuery.of(context).orientation) == Orientation.landscape;
    final isIOS = Platform.isIOS;

    final PreferredSizeWidget iOSNavBar = CupertinoNavigationBar(
      backgroundColor: navBarColor,
      middle: MyText(
        text: MyApp._navbarTitle,
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      trailing: GestureDetector(
        onTap: () => _createAndDisplayAddTransactionWidget(context),
        child: Icon(
          CupertinoIcons.add,
          size: 24,
          color: CupertinoColors.white,
        ),
      ),
    );

    final PreferredSizeWidget androidAppBar = AppBar(
      title: Text('Personal Budget'),
      backgroundColor: navBarColor,
      actions: [
        IconButton(
            onPressed: () => _createAndDisplayAddTransactionWidget(context),
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 32,
            ))
      ],
    );
    var appBarHeight = isIOS
        ? iOSNavBar.preferredSize.height
        : androidAppBar.preferredSize.height;

    var statusBarHeight = MediaQuery.of(context).padding.top;

    final appBody = _userTransactions.length > 0
        ? SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: isLandScape
                        ? (screenHeight - appBarHeight - statusBarHeight) * 0.40
                        : (screenHeight - appBarHeight - statusBarHeight) *
                            0.25,
                    width: screenWidth,
                    child: MyChart(_recentTransactions)),
                Container(
                  height: isLandScape
                      ? (screenHeight - appBarHeight - statusBarHeight) * 0.60
                      : (screenHeight - appBarHeight - statusBarHeight) * 0.75,
                  width: screenWidth,
                  child: Transactions(
                      _userTransactions.reversed.toList(), _deleteTransaction),
                )
              ],
            ),
          )
        : DashboardPlaceholder();
    return isIOS
        ? CupertinoPageScaffold(navigationBar: iOSNavBar, child: appBody)
        : Scaffold(
            backgroundColor: bgColor,
            appBar: androidAppBar,
            body: appBody,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add, color: Colors.black),
                    backgroundColor: Colors.white,
                    onPressed: () =>
                        _createAndDisplayAddTransactionWidget(context)),
          );
  }
}
