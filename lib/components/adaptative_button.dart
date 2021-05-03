import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeButton extends StatelessWidget {
  final String? label;
  final Function? onPressed;

  AdaptativeButton({
    Key? key,
    this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(label!),
            onPressed: onPressed as void Function()?,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 20),
          )
        : ElevatedButton(
            style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Theme.of(context).primaryColor),
            onPressed: onPressed as void Function()?,
            child: Text(label!),
          );
  }
}
