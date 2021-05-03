import 'dart:io';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.amber[900],
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              button:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              bodyText2: TextStyle(fontFamily: 'OpenSans', fontSize: 14)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _transactions = [];
  int idController = 0;
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: idController,
      title: title,
      value: value,
      date: date,
    );

    idController++;

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(int id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(onSubmit: _addTransaction);
        });
  }

  Widget _getIconButton({IconData icon, Function fn}) {
    return Platform.isIOS
        ? GestureDetector(onTap: fn as void Function(), child: Icon(icon))
        : IconButton(icon: Icon(icon), onPressed: fn as void Function());
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final iconList = Platform.isIOS ? CupertinoIcons.list_bullet : Icons.list;
    final iconChart = Platform.isIOS
        ? CupertinoIcons.chart_bar_square_fill
        : Icons.show_chart;

    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final actions = <Widget>[
      if (isLandscape)
        _getIconButton(
          icon: _showChart ? iconList : iconChart,
          fn: () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        icon: Platform.isIOS ? CupertinoIcons.add : Icons.add,
        fn: () => _openTransactionFormModal(context),
      ),
    ];

    final PreferredSizeWidget appBar = (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Despesas Pessoais',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          )
        : AppBar(
            title: Text(
              'Despesas Pessoais',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
            actions: actions,
          )) as PreferredSizeWidget;

    final avaliableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_showChart || !isLandscape)
                Container(
                    height: avaliableHeight * (isLandscape ? 0.7 : 0.25),
                    child: Chart(_recentTransactions)),
              if (!_showChart || !isLandscape)
                Container(
                  height: avaliableHeight * (isLandscape ? 1.0 : 0.75),
                  child: TransactionList(
                    transactions: _transactions,
                    onRemove: _deleteTransaction,
                  ),
                ),
            ],
          ),
        ));

    return Platform.isIOS
        ? CupertinoPageScaffold(navigationBar: null, child: bodyPage)
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _openTransactionFormModal(context),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
