import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdaptativeDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime?)? onDateChanged;

  AdaptativeDatePicker({Key? key, this.selectedDate, this.onDateChanged})
      : super(key: key);

  _showDatePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      onDateChanged!(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Container(
            height: 180,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              minimumDate: DateTime(2019),
              maximumDate: DateTime.now(),
              onDateTimeChanged: onDateChanged!,
            ),
          )
        : Container(
            child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedDate == null
                      ? 'Nenhuma data selecionada!'
                      : 'Data Selecionada: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                ),
              ),
              TextButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                child: Text(
                  'Selecionar Data',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () => _showDatePicker(context),
              ),
            ],
          ));
  }
}
