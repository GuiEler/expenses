import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function? onSubmitted;
  final String? label;
  final bool autofocus;
  final TextInputType keyboardType;

  AdaptativeTextField({
    Key? key,
    this.controller,
    this.onSubmitted,
    this.label,
    this.autofocus = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CupertinoTextField(
              controller: controller,
              onSubmitted: onSubmitted as void Function(String)?,
              placeholder: label,
              autofocus: autofocus,
              keyboardType: keyboardType,
              padding: EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 12,
              ),
            ),
          )
        : TextField(
            controller: controller,
            onSubmitted: onSubmitted as void Function(String)?,
            decoration: InputDecoration(labelText: label),
            autofocus: autofocus,
            keyboardType: keyboardType,
          );
  }
}
