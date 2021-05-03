import 'package:expenses/components/adaptative_button.dart';
import 'package:expenses/components/adaptative_date_picker.dart';
import 'package:expenses/components/adaptative_text_field.dart';
import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String title, double value, DateTime selectedDate)
      onSubmit;

  const TransactionForm({
    Key key,
    this.onSubmit,
  }) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate;

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }

    widget.onSubmit(title, value, _selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding:
              EdgeInsets.all(10), //+ MediaQuery.of(context).viewInsets.bottom),
          child: Column(children: <Widget>[
            AdaptativeTextField(
              controller: _titleController,
              onSubmitted: (_) => _submitForm(),
              label: 'Título',
              autofocus: true,
            ),
            AdaptativeTextField(
              controller: _valueController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitForm(),
              label: 'Valor (R\$)',
            ),
            AdaptativeDatePicker(
              selectedDate: _selectedDate,
              onDateChanged: (newDate) {
                setState(() {
                  _selectedDate == null
                      ? _selectedDate = DateTime.now()
                      : _selectedDate = newDate;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AdaptativeButton(
                    label: 'Nova Transação', onPressed: _submitForm)
              ],
            )
          ]),
        ),
      ),
    );
  }
}
