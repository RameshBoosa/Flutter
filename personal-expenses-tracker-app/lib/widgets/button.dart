import 'package:flutter/material.dart';

enum ButtonType { elevated, text, outlined }

class MyButton extends StatelessWidget {
  final Function actionHandler;
  final String buttonTitle;
  final ButtonType buttonType;

  MyButton(this.buttonTitle, this.actionHandler, this.buttonType);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      backgroundColor: Colors.red,
      alignment: Alignment.center,
    );
    var textButtonStyle = TextButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        textStyle: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold));

    return Container(
      margin: EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 8),
      width: double.infinity,
      height: 50,
      child: (buttonType == ButtonType.elevated)
          ? ElevatedButton(
              style: style,
              child: Text(buttonTitle),
              onPressed: actionHandler,
            )
          : TextButton(
              onPressed: actionHandler,
              child: Text(buttonTitle),
              style: textButtonStyle),
    );
  }
}
